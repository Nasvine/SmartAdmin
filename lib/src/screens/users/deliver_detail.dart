import 'package:cached_network_image/cached_network_image.dart';
import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/models/auth/user_model.dart';
import 'package:smart_admin/src/models/order_model.dart';
import 'package:smart_admin/src/models/transactions/transaction_model.dart';
import 'package:smart_admin/src/screens/orders/order_detail.dart';
import 'package:smart_admin/src/screens/orders/order_detail_finish.dart';
import 'package:smart_admin/src/screens/tabs.dart';
import 'package:smart_admin/src/screens/users/deliver_list.dart';
import 'package:smart_admin/src/screens/users/user_list.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/loaders/loaders.dart';
import 'package:smart_admin/src/utils/texts/button_custom.dart';
import 'package:smart_admin/src/utils/texts/dropdown_formfield_custom.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';
import 'package:smart_admin/src/utils/texts/text_form_field_simple_custom.dart';
import 'package:smart_admin/src/utils/validators/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

class DeliverDetailScreen extends StatefulWidget {
  const DeliverDetailScreen({super.key, required this.userId});
  final String userId;

  @override
  State<DeliverDetailScreen> createState() => _DeliverDetailScreenState();
}

class _DeliverDetailScreenState extends State<DeliverDetailScreen> {
  final firebase = FirebaseFirestore.instance;
  bool isCharged = false;
  UserModel user = UserModel(
    fullName: "",
    email: "",
    phoneNumber: "",
    userRole: 'Deliver',
    userAdress: "",
    isAvailable: false,
    geopoint: GeoPoint(0, 0),
  );
  /*  */

  void fetchDataUser() async {
    setState(() {
      isCharged = true;
    });
    if (widget.userId == "") return;
    try {
      final data = await firebase.collection('users').doc(widget.userId).get();
      print(data);

      if (data.exists) {
        final verifyItem = UserModel.fromSnapshot(data);
        setState(() {
          user = verifyItem;
          isCharged = false;
        });
      }
    } catch (e) {
      setState(() {
        isCharged = false;
      });
      TLoaders.errorSnackBar(title: "Erreur: $e");
    }
  }

  Stream<int> getOrderFinishTodayTotal(String userId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return FirebaseFirestore.instance
        .collection('orders')
        .where(
          'deliverRef',
          isEqualTo: FirebaseFirestore.instance.collection('users').doc(userId),
        )
        .where('status', isEqualTo: "completed")
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          isLessThan: Timestamp.fromDate(endOfDay),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getOrderFinishTodayTotalAmount(String userId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return FirebaseFirestore.instance
        .collection('orders')
        .where(
          'deliverRef',
          isEqualTo: FirebaseFirestore.instance.collection('users').doc(userId),
        )
        .where('status', isEqualTo: "completed")
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          isLessThan: Timestamp.fromDate(endOfDay),
        )
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return 0;

          double total = 0;

          for (final doc in snapshot.docs) {
            final data = doc.data();
            final amount = (data['amount'] as num).toDouble();
            total += amount;
          }

          return total.toInt();
        });
  }

  Stream<int> getOrderPendingTotal(String userId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return FirebaseFirestore.instance
        .collection('orders')
        .where(
          'deliverRef',
          isEqualTo: FirebaseFirestore.instance.collection('users').doc(userId),
        )
        .where('paymentStatus', isEqualTo: "Pending")
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          isLessThan: Timestamp.fromDate(endOfDay),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getOrderFinishTotal(String userId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where(
          'deliverRef',
          isEqualTo: FirebaseFirestore.instance.collection('users').doc(userId),
        )
        .where('status', isEqualTo: "completed")
        .where('paymentStatus', isEqualTo: "Completed")
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return 0;

          return snapshot.docs.length;
        });
  }

  Stream<double> getUserBalance(String userId) {
    return FirebaseFirestore.instance
        .collection('wallets')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return 0;
          final data = snapshot.docs.first;
          final amount = (data['amount'] as num).toDouble();
          return amount;
        });
  }

  Stream<List<TransactionModel>> getTransactions(String userId) {
    return FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TransactionModel.fromSnapshot(doc))
              .toList(),
        );
  }

  Stream<List<OrderModel>> getOrdersFinishLists(String userId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .orderBy("createdAt", descending: true)
        .where('paymentStatus', isEqualTo: "Completed")
        .where('status', isEqualTo: "completed")
        .where(
          'deliverRef',
          isEqualTo: FirebaseFirestore.instance.collection('users').doc(userId),
        )
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList(),
        );
  }

  @override
  void initState() {
    fetchDataUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            LineAwesomeIcons.angle_left_solid,
            color: THelperFunctions.isDarkMode(context)
                ? ColorApp.tWhiteColor
                : ColorApp.tBlackColor,
          ),
          onPressed: () => Get.offAll(() => const DeliverListScreen()),
        ),
        title: TextCustom(TheText: 'Détails sur le Livreur', TheTextSize: 14),
        centerTitle: true,
      ),

      body: isCharged ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: BoxBorder.all(
                    width: 0.5,
                    color: THelperFunctions.isDarkMode(context)
                        ? ColorApp.tWhiteColor
                        : ColorApp.tBlackColor,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        user.profilePicture == "" || user.profilePicture == null
                            ? CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(
                                  "assets/images/cover.jpg",
                                ),
                              )
                            : Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    user.profilePicture!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        SizedBox(width: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextCustom(
                                TheText: user.fullName,
                                TheTextFontWeight: FontWeight.bold,
                                TheTextSize: 15,
                              ),
                              TextCustom(
                                TheText: user.userRole,
                                TheTextFontWeight: FontWeight.normal,
                                TheTextSize: 13,
                              ),
                              TextCustom(
                                TheText: user.email,
                                TheTextFontWeight: FontWeight.normal,
                                TheTextSize: 13,
                              ),
                              TextCustom(
                                TheText: user.phoneNumber,
                                TheTextFontWeight: FontWeight.normal,
                                TheTextSize: 13,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 168,
                      height: 80,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 251, 217, 173),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            StreamBuilder(
                              stream: getUserBalance(user.ref!.id),
                              builder: (context, asyncSnapshot) {
                                if (!asyncSnapshot.hasData) {
                                  return Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return TextCustom(
                                  TheText: "${asyncSnapshot.data!} F",
                                  TheTextSize: 14,
                                  TheTextFontWeight: FontWeight.bold,
                                  TheTextColor: ColorApp.tBlackColor,
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            TextCustom(
                              TheText: "Gains total",
                              TheTextSize: 12,
                              TheTextFontWeight: FontWeight.bold,
                              TheTextColor: ColorApp.tBlackColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 168,
                      height: 80,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(57, 74, 177, 255),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            StreamBuilder(
                              stream: getOrderFinishTotal(user.ref!.id),
                              builder: (context, asyncSnapshot) {
                                if (!asyncSnapshot.hasData) {
                                  return Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return TextCustom(
                                  TheText: "${asyncSnapshot.data!}",
                                  TheTextSize: 14,
                                  TheTextFontWeight: FontWeight.bold,
                                  TheTextColor:
                                      THelperFunctions.isDarkMode(context)
                                      ? ColorApp.tWhiteColor
                                      : ColorApp.tBlackColor,
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            TextCustom(
                              TheText: "Courses Totales",
                              TheTextSize: 12,
                              TheTextFontWeight: FontWeight.bold,
                              TheTextColor: THelperFunctions.isDarkMode(context)
                                  ? ColorApp.tWhiteColor
                                  : ColorApp.tBlackColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 168,
                      height: 80,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 251, 217, 173),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            StreamBuilder(
                              stream: getOrderFinishTodayTotalAmount(
                                user.ref!.id,
                              ),
                              builder: (context, asyncSnapshot) {
                                if (!asyncSnapshot.hasData) {
                                  return CircularProgressIndicator();
                                }
                                return TextCustom(
                                  TheText: "${asyncSnapshot.data} F",
                                  TheTextSize: 14,
                                  TheTextFontWeight: FontWeight.bold,
                                  TheTextColor: ColorApp.tBlackColor,
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            TextCustom(
                              TheText: "Gains du jour",
                              TheTextSize: 12,
                              TheTextFontWeight: FontWeight.bold,
                              TheTextColor: ColorApp.tBlackColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 168,
                      height: 80,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(57, 74, 177, 255),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            StreamBuilder(
                              stream: getOrderFinishTodayTotal(user.ref!.id),
                              builder: (context, asyncSnapshot) {
                                if (!asyncSnapshot.hasData) {
                                  return Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return TextCustom(
                                  TheText: "${asyncSnapshot.data!}",
                                  TheTextSize: 14,
                                  TheTextFontWeight: FontWeight.bold,
                                  TheTextColor:
                                      THelperFunctions.isDarkMode(context)
                                      ? ColorApp.tWhiteColor
                                      : ColorApp.tBlackColor,
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            TextCustom(
                              TheText: "Courses journalières",
                              TheTextSize: 12,
                              TheTextFontWeight: FontWeight.bold,
                              TheTextColor: THelperFunctions.isDarkMode(context)
                                  ? ColorApp.tWhiteColor
                                  : ColorApp.tBlackColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 168,
                      height: 80,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(57, 74, 177, 255),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            StreamBuilder(
                              stream: getOrderPendingTotal(user.ref!.id),
                              builder: (context, asyncSnapshot) {
                                if (!asyncSnapshot.hasData) {
                                  return Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return TextCustom(
                                  TheText: "${asyncSnapshot.data!}",
                                  TheTextSize: 14,
                                  TheTextFontWeight: FontWeight.bold,
                                  TheTextColor:
                                      THelperFunctions.isDarkMode(context)
                                      ? ColorApp.tWhiteColor
                                      : ColorApp.tBlackColor,
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            TextCustom(
                              TheText: "Courses en cours",
                              TheTextSize: 12,
                              TheTextFontWeight: FontWeight.bold,
                              TheTextColor: THelperFunctions.isDarkMode(context)
                                  ? ColorApp.tWhiteColor
                                  : ColorApp.tBlackColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 168,
                      height: 80,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 251, 217, 173),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            StreamBuilder(
                              stream: getOrderFinishTotal(user.ref!.id),
                              builder: (context, asyncSnapshot) {
                                if (!asyncSnapshot.hasData) {
                                  return CircularProgressIndicator();
                                }
                                return TextCustom(
                                  TheText: "${asyncSnapshot.data!}",
                                  TheTextSize: 14,
                                  TheTextFontWeight: FontWeight.bold,
                                  TheTextColor: ColorApp.tBlackColor,
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            TextCustom(
                              TheText: "Courses terminées",
                              TheTextSize: 12,
                              TheTextFontWeight: FontWeight.bold,
                              TheTextColor: ColorApp.tBlackColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextCustom(
                    TheText: 'Historiques des livraisons',
                    TheTextSize: 15,
                    TheTextFontWeight: FontWeight.bold,
                    TheTextColor: THelperFunctions.isDarkMode(context)
                        ? ColorApp.tWhiteColor
                        : ColorApp.tBlackColor,
                  ),
                ],
              ),
              SizedBox(height: 10),
              StreamBuilder(
                stream: getOrdersFinishLists(user.ref!.id),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: ColorApp.tsombreBleuColor,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Lottie.asset(
                              height: 150,
                              width: 150,
                              'assets/images/no_data.json',
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 5),
                            TextCustom(
                              TheText: "Aucune livraison récente.",
                              TheTextSize: 13,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final order = asyncSnapshot.data!;

                  return ListView.builder(
                    itemCount: order.length,
                    shrinkWrap: true, // Important pour éviter overflow
                    physics:
                        const NeverScrollableScrollPhysics(), // Empêche conflit scroll
                    itemBuilder: (context, index) {
                      final orderItem = order[index];
                      return InkWell(
                        onTap: () {
                          Get.offAll(
                            () => OrderDetailFinishScreen(
                              endLocation: orderItem.destinationLocation,
                              startLocation: orderItem.withdrawalPoint,
                              orderId: orderItem.uid!,
                              userCreatedId: orderItem.userRef!.id,
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 140,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            border: BoxBorder.all(
                              color: Color.fromARGB(57, 74, 177, 255),
                            ),
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromARGB(57, 74, 177, 255),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextCustom(
                                    TheText: DateFormat(
                                      'd/M/y - H:m',
                                    ).format(orderItem.createdAt.toDate()),
                                    TheTextSize: 13,
                                    TheTextFontWeight: FontWeight.normal,
                                  ),
                                  Container(
                                    width: 90,
                                    height: 30,
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: ColorApp.tsecondaryColor,
                                      ),
                                    ),
                                    child: Center(
                                      child: Expanded(
                                        child: TextCustom(
                                          TheText: orderItem.status,
                                          TheTextSize: 12,
                                          TheTextFontWeight: FontWeight.bold,
                                          TheTextColor:
                                              ColorApp.tsecondaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextCustom(
                                    TheText: "# ${orderItem.orderId}",
                                    TheTextSize: 13,
                                    TheTextFontWeight: FontWeight.bold,
                                  ),
                                  TextCustom(
                                    TheText: "${orderItem.amount.toInt()} F",
                                    TheTextSize: 13,
                                    TheTextFontWeight: FontWeight.normal,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextCustom(
                                    TheText:
                                        "Distance: ${orderItem.distance.toStringAsFixed(2)} Km",
                                    TheTextSize: 13,
                                    TheTextFontWeight: FontWeight.normal,
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextCustom(
                    TheText: 'Historiques des transactions',
                    TheTextSize: 15,
                    TheTextFontWeight: FontWeight.bold,
                    TheTextColor: THelperFunctions.isDarkMode(context)
                        ? ColorApp.tWhiteColor
                        : ColorApp.tBlackColor,
                  ),
                ],
              ),
              SizedBox(height: 10),
              StreamBuilder(
                stream: getTransactions(user.ref!.id),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: ColorApp.tsombreBleuColor,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Lottie.asset(
                              height: 150,
                              width: 150,
                              'assets/images/no_data.json',
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 5),
                            TextCustom(
                              TheText: "Aucune transaction trouvé(e).",
                              TheTextSize: 13,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final transaction = asyncSnapshot.data!;

                  return ListView.builder(
                    itemCount: transaction.length,
                    shrinkWrap: true, // Important pour éviter overflow
                    physics:
                        const NeverScrollableScrollPhysics(), // Empêche conflit scroll
                    itemBuilder: (context, index) {
                      final traansactionItem = transaction[index];
                      return Container(
                        height: 120,
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(255, 74, 74, 74),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextCustom(
                                  TheText:
                                      "Transaction #${traansactionItem.reference}",
                                  TheTextSize: 14,
                                  TheTextFontWeight: FontWeight.bold,
                                ),
                                TextCustom(
                                  TheText: DateFormat(
                                    'd/M/y - HH:mm',
                                  ).format(traansactionItem.createdAt.toDate()),
                                  TheTextSize: 12,
                                ),
                                if (traansactionItem.status == "completed")
                                  Container(
                                    height: 30,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.green,
                                    ),
                                    child: Center(
                                      child: TextCustom(
                                        TheText: traansactionItem.status,
                                        TheTextSize: 12,
                                      ),
                                    ),
                                  ),

                                if (traansactionItem.status == "failed")
                                  Container(
                                    height: 30,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.red,
                                    ),
                                    child: Center(
                                      child: TextCustom(
                                        TheText: traansactionItem.status,
                                        TheTextSize: 12,
                                      ),
                                    ),
                                  ),

                                if (traansactionItem.status == "pending")
                                  Container(
                                    height: 30,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey,
                                    ),
                                    child: Center(
                                      child: TextCustom(
                                        TheText: traansactionItem.status,
                                        TheTextSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Row(
                              children: [
                                if (traansactionItem.type == "payment")
                                  TextCustom(
                                    TheText: "+ ${traansactionItem.amount}",
                                    TheTextSize: 15,
                                    TheTextColor: Colors.green,
                                    TheTextFontWeight: FontWeight.bold,
                                  ),
                                if (traansactionItem.type == "withdrawal")
                                  TextCustom(
                                    TheText: "- ${traansactionItem.amount}",
                                    TheTextSize: 15,
                                    TheTextColor: Colors.red,
                                    TheTextFontWeight: FontWeight.bold,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
