import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:smart_admin/notification_services.dart';
import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/models/auth/notification_model.dart';
import 'package:smart_admin/src/models/auth/user_model.dart';
import 'package:smart_admin/src/models/order_model.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';

class SeeDeliverPositionScreen extends StatefulWidget {
  const SeeDeliverPositionScreen({
    super.key,
    required this.startLocation,
    required this.orderId,
    required this.clientId,
  });

  final PlaceLocation startLocation;
  final String orderId;
  final String clientId;

  @override
  State<SeeDeliverPositionScreen> createState() =>
      _SeeDeliverPositionScreenState();
}

class _SeeDeliverPositionScreenState extends State<SeeDeliverPositionScreen> {
  final firebase = FirebaseFirestore.instance;
  UserModel clientInfo = UserModel.empty();
  OrderModel orderData = OrderModel.empty();
  GoogleMapController? _mapController;
  List<Map<String, dynamic>> _deliverers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchDeliverers();
    _getClientInfo();
  }

  Stream<OrderModel> fetchOrderDetails() {
    final data = firebase.collection('orders').doc(widget.orderId).get();

    return FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .snapshots()
        .map((snapshot) {
          return OrderModel.fromSnapshot(snapshot);
        });
  }

  void _getClientInfo() async {
    final data = await firebase.collection("users").doc(widget.clientId).get();
    if (data.exists) {
      final client = UserModel.fromSnapshot(data);
      setState(() {
        clientInfo = client;
      });
    } else {
      print('No data');
    }
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

  Future<void> _fetchDeliverers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("userRole", isEqualTo: "Deliver")
          .get();

      final List<Map<String, dynamic>> deliverers = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data.containsKey("geopoint") && data["geopoint"] is GeoPoint) {
          final GeoPoint gp = data["geopoint"];
          final distance = _calculateDistanceBetween(
            widget.startLocation.latitude,
            widget.startLocation.longitude,
            gp.latitude,
            gp.longitude,
          );

          deliverers.add({
            "id": doc.id,
            "ref": doc.reference,
            "name": data["fullName"] ?? "Sans nom",
            "latitude": gp.latitude,
            "longitude": gp.longitude,
            "distance": distance,
          });
        }
      }

      // Trier par distance croissante
      deliverers.sort((a, b) => a["distance"].compareTo(b["distance"]));

      setState(() {
        _deliverers = deliverers;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Erreur récupération livreurs: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng startLatLng = LatLng(
      widget.startLocation.latitude,
      widget.startLocation.longitude,
    );

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId("start"),
        position: startLatLng,
        infoWindow: InfoWindow(
          title: "Point de départ",
          snippet: widget.startLocation.address,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      ..._deliverers.map(
        (d) => Marker(
          markerId: MarkerId(d["id"]),
          position: LatLng(d["latitude"], d["longitude"]),
          infoWindow: InfoWindow(
            title: d["name"],
            snippet: "${d["distance"].toStringAsFixed(2)} km",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      ),
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            LineAwesomeIcons.angle_left_solid,
            color: THelperFunctions.isDarkMode(context)
                ? ColorApp.tWhiteColor
                : ColorApp.tBlackColor,
          ),
        ),
        centerTitle: true,
        title: const Text("Livreurs disponibles"),
      ),
      body: StreamBuilder(
        stream: fetchOrderDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorApp.tsombreBleuColor,
              ),
              child: Center(
                child: TextCustom(
                  TheText: "Course non trouvée",
                  TheTextSize: 13,
                ),
              ),
            );
          }

          final order = snapshot.data!;

          return Column(
            children: [
              /// Map avec coins arrondis
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: startLatLng,
                      zoom: 12,
                    ),
                    markers: markers,
                    onMapCreated: (controller) => _mapController = controller,
                  ),
                ),
              ),

              /// Liste des livreurs triés par distance
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _deliverers.length,
                        itemBuilder: (context, index) {
                          final d = _deliverers[index];
                          return ListTile(
                            leading: const Icon(
                              Icons.delivery_dining,
                              color: Colors.blue,
                            ),
                            title: TextCustom(
                              TheText: d["name"],
                              TheTextSize: 13,
                              TheTextFontWeight: FontWeight.bold,
                            ),
                            subtitle: TextCustom(
                              TheText:
                                  "Distance : ${d["distance"].toStringAsFixed(2)} km",
                              TheTextSize: 12,
                              TheTextFontWeight: FontWeight.normal,
                            ),
                            trailing: Column(
                              children: [
                                Container(
                                  width: 100,
                                  margin: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (order.isDriverAssigned == false)
                                        GestureDetector(
                                          onTap: () async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                  "Confirmation",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: const Text(
                                                  "Voulez-vous vraiment attribuer la course à ce livreur ?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                          context,
                                                          false,
                                                        ),
                                                    child: const Text("Non"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                          context,
                                                          true,
                                                        ),
                                                    child: const Text(
                                                      "Oui",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirm == true) {
                                              try {
                                                final firebase =
                                                    FirebaseFirestore.instance;

                                                try {
                                                  await firebase
                                                      .collection('orders')
                                                      .doc(widget.orderId)
                                                      .update({
                                                        'isDriverAssigned':
                                                            true,
                                                        'status': "assigned",
                                                        'deliverRef': d['ref'],
                                                        'managerRef':
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                  "users",
                                                                )
                                                                .doc(
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid,
                                                                ),
                                                      });

                                                  final notification =
                                                      NotificationModel(
                                                        senderRef:
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                  'users',
                                                                )
                                                                .doc(
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid,
                                                                ),
                                                        receiverRef: d['ref'],
                                                        title:
                                                            'Nouvelle Course',
                                                        message:
                                                            "Vous avez une nouvelle course de ${clientInfo.fullName}. Veuillez l'accepter.",
                                                        type: "Location",
                                                        isRead: false,
                                                        createdAt:
                                                            Timestamp.now(),
                                                      );

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                        'notifications',
                                                      )
                                                      .add(
                                                        notification.toJson(),
                                                      );

                                                  NotificationServices()
                                                      .sendPushNotification(
                                                        deviceToken: clientInfo
                                                            .fcmToken!,
                                                        title:
                                                            "Nouvelle Course 👋",
                                                        body:
                                                            "Vous avez une nouvelle course de ${clientInfo.fullName}. Veuillez l'accepter.",
                                                      );

                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Statut mis à jour : Assigné',
                                                      ),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  print(
                                                    'Erreur de mise à jour du statut: $e',
                                                  );
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Erreur lors de la mise à jour',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Erreur lors de la suppression : $e",
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.green,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      if (order.isDriverAssigned == true)
                                        GestureDetector(
                                          onTap: () async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                  "Confirmation",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: const Text(
                                                  "Voulez-vous vraiment désassigner la course à ce livreur ?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                          context,
                                                          false,
                                                        ),
                                                    child: const Text("Non"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                          context,
                                                          true,
                                                        ),
                                                    child: const Text(
                                                      "Oui",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirm == true) {
                                              try {
                                                final firebase =
                                                    FirebaseFirestore.instance;

                                                try {
                                                  await firebase
                                                      .collection('orders')
                                                      .doc(widget.orderId)
                                                      .update({
                                                        'status': "neworder",
                                                        'deliverRef': null,
                                                        'managerRef': null,
                                                        'isDriverAssigned':
                                                            false,
                                                      });

                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Statut mis à jour : Nouveau',
                                                      ),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  print(
                                                    'Erreur de mise à jour du statut: $e',
                                                  );
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Erreur lors de la mise à jour',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Erreur lors de la suppression : $e",
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.red,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.clear_rounded,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
