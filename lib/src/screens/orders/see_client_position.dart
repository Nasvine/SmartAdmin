

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_admin/src/models/order_model.dart';

class SeeClientPositionScreen extends StatefulWidget {
  const SeeClientPositionScreen({
    super.key,
    required this.startLocation,
    required this.endLocation,
  });

  final PlaceLocation startLocation;
  final PlaceLocation endLocation;

  @override
  State<SeeClientPositionScreen> createState() => _SeeClientPositionScreenState();
}

class _SeeClientPositionScreenState extends State<SeeClientPositionScreen> {
  GoogleMapController? _mapController;
  double _distanceKm = 0.0;

  late LatLng _currentPosition; // Position actuelle du livreur
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _calculateDistance();

    _currentPosition = LatLng(
      widget.startLocation.latitude,
      widget.startLocation.longitude,
    );

    _startMovingSimulation(); // <- si tu veux juste simuler
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Formule Haversine
  double _calculateDistanceBetween(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // PI / 180
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) *
            cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p)) /
            2;
    return 12742 * asin(sqrt(a)); // 2 * R * asin...
  }

  void _calculateDistance() {
    _distanceKm = _calculateDistanceBetween(
      widget.startLocation.latitude,
      widget.startLocation.longitude,
      widget.endLocation.latitude,
      widget.endLocation.longitude,
    );
  }

  /// --- Simulation du déplacement du livreur ---
  void _startMovingSimulation() {
    const duration = Duration(seconds: 1);
    const step = 0.001; // plus petit = mouvement plus lent

    _timer = Timer.periodic(duration, (timer) {
      final dx = widget.endLocation.latitude - _currentPosition.latitude;
      final dy = widget.endLocation.longitude - _currentPosition.longitude;

      // si proche de la destination, on arrête
      if (dx.abs() < 0.0001 && dy.abs() < 0.0001) {
        timer.cancel();
        return;
      }

      // mise à jour progressive
      final newLat = _currentPosition.latitude + step * dx.sign;
      final newLng = _currentPosition.longitude + step * dy.sign;

      setState(() {
        _currentPosition = LatLng(newLat, newLng);
      });

      // centrer la caméra sur le livreur
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_currentPosition),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final LatLng startLatLng =
        LatLng(widget.startLocation.latitude, widget.startLocation.longitude);
    final LatLng endLatLng =
        LatLng(widget.endLocation.latitude, widget.endLocation.longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Suivi du trajet"),
      ),
      body: Column(
        children: [
          /// Map avec livreur en temps réel
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: startLatLng,
                zoom: 13,
              ),
              onMapCreated: (controller) => _mapController = controller,
              markers: {
                Marker(
                  markerId: const MarkerId("start"),
                  position: startLatLng,
                  infoWindow: InfoWindow(
                    title: "Départ",
                    snippet: widget.startLocation.address,
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                ),
                Marker(
                  markerId: const MarkerId("end"),
                  position: endLatLng,
                  infoWindow: InfoWindow(
                    title: "Arrivée",
                    snippet: widget.endLocation.address,
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                ),
                Marker(
                  markerId: const MarkerId("livreur"),
                  position: _currentPosition,
                  infoWindow: const InfoWindow(title: "Livreur en route"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  color: Colors.red,
                  width: 4,
                  points: [startLatLng, _currentPosition],
                ),
              },
            ),
          ),

          /// Espace infos
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Distance totale : ${_distanceKm.toStringAsFixed(2)} km",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Position actuelle : ${_currentPosition.latitude.toStringAsFixed(4)}, "
                    "${_currentPosition.longitude.toStringAsFixed(4)}",
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _timer?.cancel(),
                    icon: const Icon(Icons.stop),
                    label: const Text("Arrêter le suivi"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

