import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/models/auth/user_model.dart';
import 'package:smart_admin/src/models/order_model.dart';
import 'package:smart_admin/src/repository/authentification_repository.dart';
import 'package:smart_admin/src/screens/users/deliver_detail.dart';
import 'package:smart_admin/src/screens/users/deliver_list.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/loaders/loaders.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

class OrderDetailFinishScreen extends StatefulWidget {
  const OrderDetailFinishScreen({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.userCreatedId,
    required this.orderId,
  });

  final PlaceLocation startLocation; // Point de départ
  final PlaceLocation endLocation; // Point d’arrivée
  final String userCreatedId;
  final String orderId;

  @override
  State<OrderDetailFinishScreen> createState() =>
      _OrderDetailFinishScreenState();
}

class _OrderDetailFinishScreenState extends State<OrderDetailFinishScreen> {
  final firebase = FirebaseFirestore.instance;
  bool isCharged = false;
  OrderModel orderData = OrderModel.empty();
  GoogleMapController? _mapController;
  double _distanceKm = 0.0;
  UserModel clientInfo = UserModel.empty();

  @override
  void initState() {
    super.initState();
    _calculateDistance();
    _getClientInfo();
    _fetchOrderDetails();
  }

  /// Formule Haversine
  double _calculateDistanceBetween(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const p = 0.017453292519943295; // PI / 180
    final a =
        0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
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

  void _getClientInfo() async {
    final data = await firebase
        .collection("users")
        .doc(widget.userCreatedId)
        .get();
    if (data.exists) {
      final client = UserModel.fromSnapshot(data);
      setState(() {
        clientInfo = client;
      });
    } else {
      print('No data');
    }
  }

  void _fetchOrderDetails() async {
    setState(() {
      isCharged = true;
    });
    try {
      final data = await firebase
          .collection('orders')
          .doc(widget.orderId)
          .get();

      if (data.exists) {
        final order = OrderModel.fromSnapshot(data);
        setState(() {
          orderData = order;
          isCharged = false;
        });
      } else {
        print('No data');
      }
    } catch (e) {
      setState(() {
        isCharged = false;
      });
      TLoaders.errorSnackBar(title: "Erreur: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng startLatLng = LatLng(
      widget.startLocation.latitude,
      widget.startLocation.longitude,
    );
    final LatLng endLatLng = LatLng(
      widget.endLocation.latitude,
      widget.endLocation.longitude,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.offAll(
            () => DeliverDetailScreen(userId: orderData.userRef!.id),
          ),
          icon: Icon(
            LineAwesomeIcons.angle_left_solid,
            color: THelperFunctions.isDarkMode(context)
                ? ColorApp.tWhiteColor
                : ColorApp.tBlackColor,
          ),
        ),
        centerTitle: true,
        title: const Text("Détail de la course"),
      ),
      body: isCharged
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    /// Map sur la moitié de l'écran
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              (startLatLng.latitude + endLatLng.latitude) / 2,
                              (startLatLng.longitude + endLatLng.longitude) / 2,
                            ),
                            zoom: 11,
                          ),
                          onMapCreated: (controller) =>
                              _mapController = controller,

                          // === Ajout des interactions ===
                          zoomGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          rotateGesturesEnabled: true,
                          tiltGesturesEnabled: true,
                          compassEnabled: true,
                          myLocationButtonEnabled: false,
                           gestureRecognizers:
                              <Factory<OneSequenceGestureRecognizer>>{
                                Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer(),
                                ),
                              },

                          // === Markers ===
                          markers: {
                            Marker(
                              markerId: const MarkerId("start"),
                              position: startLatLng,
                              infoWindow: InfoWindow(
                                title: "Départ",
                                snippet: widget.startLocation.address,
                              ),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueGreen,
                              ),
                            ),
                            Marker(
                              markerId: const MarkerId("end"),
                              position: endLatLng,
                              infoWindow: InfoWindow(
                                title: "Arrivée",
                                snippet: widget.endLocation.address,
                              ),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueRed,
                              ),
                            ),
                          },

                          // === Polyline ===
                          polylines: {
                            Polyline(
                              polylineId: const PolylineId("route"),
                              color: Colors.red,
                              width: 4,
                              points: [startLatLng, endLatLng],
                            ),
                          },
                         
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.orange.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.person_2_outlined,
                                  color: ColorApp.tWhiteColor,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: "Nom & Prénoms du Client",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.bold,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText:
                                            "${clientInfo.fullName}" ??
                                            "0198989898",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.normal,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(indent: 5, endIndent: 5),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.orange.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.phone,
                                  color: ColorApp.tWhiteColor,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: "Numéro du Client",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.bold,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: "${clientInfo.phoneNumber}",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.normal,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(indent: 5, endIndent: 5),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.orange.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: ColorApp.tWhiteColor,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: "Adresse de retrait",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.bold,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText:
                                            "${widget.startLocation.address}",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.normal,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(indent: 5, endIndent: 5),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.orange.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: ColorApp.tWhiteColor,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: "Adresse de destination",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.bold,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText:
                                            "${widget.endLocation.address}",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.normal,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(indent: 5, endIndent: 5),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.orange.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.info_outlined,
                                  color: ColorApp.tWhiteColor,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: "Instructions de Client",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.bold,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          TextCustom(
                                            TheText: "${orderData.message}",
                                            TheTextSize: 13,
                                            TheTextFontWeight:
                                                FontWeight.normal,
                                            TheTextColor:
                                                THelperFunctions.isDarkMode(
                                                  context,
                                                )
                                                ? ColorApp.tWhiteColor
                                                : ColorApp.tBlackColor,
                                            TheTextMaxLines: 20,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(indent: 5, endIndent: 5),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.orange.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.toys_rounded,
                                  color: ColorApp.tWhiteColor,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: "Type de colis",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.bold,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: "${orderData.deliveryType}",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.normal,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(indent: 5, endIndent: 5),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.orange.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.motorcycle,
                                  color: ColorApp.tWhiteColor,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: "Distance",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.bold,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText:
                                            "${orderData.distance.toStringAsFixed(2)} Km",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.normal,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(indent: 5, endIndent: 5),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.orange.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.money_rounded,
                                  color: ColorApp.tWhiteColor,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: "Prix de la course",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.bold,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText:
                                            "${orderData.amount.toStringAsFixed(2)} FCFA",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.normal,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(indent: 5, endIndent: 5),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.orange.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.comment,
                                  color: ColorApp.tWhiteColor,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: "Commentaire du client",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.bold,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: orderData.clientReviews!,
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.normal,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(indent: 5, endIndent: 5),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.orange.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.note,
                                  color: ColorApp.tWhiteColor,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: "Note du client",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.bold,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      if (orderData.clientRating != 0)
                                        ...List.generate(
                                          orderData
                                              .clientRating, // nombre d'étoiles
                                          (index) => const Icon(
                                            Icons.star,
                                            color: Colors
                                                .amber, // couleur des étoiles
                                            size: 18, // taille
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(indent: 5, endIndent: 5),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.orange.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.comment,
                                  color: ColorApp.tWhiteColor,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: "Commentaire du livreur",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.bold,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: orderData.deliverReviews!,
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.normal,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(indent: 5, endIndent: 5),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.orange.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.note,
                                  color: ColorApp.tWhiteColor,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextCustom(
                                        TheText: "Note du Livreur",
                                        TheTextSize: 13,
                                        TheTextFontWeight: FontWeight.bold,
                                        TheTextColor:
                                            THelperFunctions.isDarkMode(context)
                                            ? ColorApp.tWhiteColor
                                            : ColorApp.tBlackColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      if (orderData.deliverRating != 0)
                                        ...List.generate(
                                          orderData
                                              .clientRating, // nombre d'étoiles
                                          (index) => const Icon(
                                            Icons.star,
                                            color: Colors
                                                .amber, // couleur des étoiles
                                            size: 18, // taille
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
