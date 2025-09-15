import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';

class TrackDeliveryPage extends StatefulWidget {
  final String orderId;
  final String googleApiKey;

  const TrackDeliveryPage({
    Key? key,
    required this.orderId,
    required this.googleApiKey,
  }) : super(key: key);

  @override
  State<TrackDeliveryPage> createState() => _TrackDeliveryPageState();
}

class _TrackDeliveryPageState extends State<TrackDeliveryPage> {
  GoogleMapController? _mapController;
  LatLng? _deliverPos;
  LatLng? _destinationPos;
  List<LatLng> _polylineCoords = [];
  Set<Polyline> _polylines = {};

  StreamSubscription<DocumentSnapshot>? _orderSub;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _listenOrderChanges();
  }

  void _listenOrderChanges() {
    _orderSub = FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderId)
        .snapshots()
        .listen((doc) {
          if (!doc.exists) return;
          final data = doc.data() as Map<String, dynamic>;

          final deliver = PlaceLocation.fromMap(data["deliverLocation"]);
          final destination = PlaceLocation.fromMap(
            data["destinationLocation"],
          );

          setState(() {
            _deliverPos = LatLng(deliver.latitude, deliver.longitude);
            _destinationPos = LatLng(
              destination.latitude,
              destination.longitude,
            );
            _isLoading = false;
          });

          _updatePolyline();
        });
  }

  Future<void> _updatePolyline() async {
    if (_deliverPos == null || _destinationPos == null) return;

    final start = PointLatLng(_deliverPos!.latitude, _deliverPos!.longitude);
    final end = PointLatLng(
      _destinationPos!.latitude,
      _destinationPos!.longitude,
    );

    final result = await PolylinePoints().getRouteBetweenCoordinates(
      googleApiKey: widget.googleApiKey,
      request: PolylineRequest(
        origin: start,
        destination: end,
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      setState(() {
        _polylineCoords = result.points
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();
        _polylines = {
          Polyline(
            polylineId: const PolylineId("route"),
            color: Colors.red,
            width: 4,
            points: _polylineCoords,
          ),
        };
      });
    }
  }

  @override
  void dispose() {
    _orderSub?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initPos = _destinationPos ?? const LatLng(0, 0);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            LineAwesomeIcons.angle_left_solid,
            color: THelperFunctions.isDarkMode(context)
                ? ColorApp.tWhiteColor
                : ColorApp.tBlackColor,
          ),
        ),
        centerTitle: true,
        title: const Text("Suivi du livreur"),
      ),
      body: Stack(
        children: [
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (!_isLoading)
            GoogleMap(
              initialCameraPosition: CameraPosition(target: initPos, zoom: 14),
              onMapCreated: (c) => _mapController = c,
              markers: {
                if (_deliverPos != null)
                  Marker(
                    markerId: const MarkerId("deliver"),
                    position: _deliverPos!,
                    infoWindow: const InfoWindow(title: "Position du livreur"),
                  ),
                if (_destinationPos != null)
                  Marker(
                    markerId: const MarkerId("destination"),
                    position: _destinationPos!,
                    infoWindow: const InfoWindow(title: "Point de destination"),
                  ),
              },
              polylines: _polylines,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
            ),
        ],
      ),
    );
  }
}
