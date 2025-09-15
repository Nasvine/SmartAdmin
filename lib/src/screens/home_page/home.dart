import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/models/auth/user_model.dart';
import 'package:smart_admin/src/models/order_model.dart';
import 'package:smart_admin/src/screens/verify_account/verify_account.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/texts/button_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_custom/text_custom.dart';
import 'package:intl/intl.dart';
import 'package:smart_admin/src/models/transactions/transaction_model.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.userFullName,
    required this.userEmail,
  });

  final String userFullName;
  final String userEmail;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final carouselController = CarouselController();
  UserModel clientInfo = UserModel.empty();
  bool _hasFetchedClientInfo = false;

  Stream<double> getBalanceTotale() {
    return FirebaseFirestore.instance
        .collection('transactions')
        .where('status', isEqualTo: 'completed')
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return 0;

          double totalPayments = 0;
          double totalWithdrawals = 0;

          for (var doc in snapshot.docs) {
            final data = doc.data();
            final amount = (data['amount'] as num).toDouble();
            final type = data['type'];

            if (type == 'payment') {
              totalPayments += amount;
            } else if (type == 'withdrawal') {
              totalWithdrawals += amount;
            } else if (type == 'cash') {
              totalPayments += amount;
            }
          }

          return totalPayments - totalWithdrawals;
        });
  }

  Stream<double> getUserBalanceToday(String userId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'completed')
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          isLessThan: Timestamp.fromDate(endOfDay),
        )
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return 0;

          double totalPayments = 0;
          double totalWithdrawals = 0;

          for (var doc in snapshot.docs) {
            final data = doc.data();
            final amount = (data['amount'] as num).toDouble();
            final type = data['type'];

            if (type == 'payment') {
              totalPayments += amount;
            } else if (type == 'withdrawal') {
              totalWithdrawals += amount;
            }
          }

          return totalPayments - totalWithdrawals;
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

  Stream<int> getTotalDeliver() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('userRole', isEqualTo: 'Deliver')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getTotalDeliverAvailable() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('userRole', isEqualTo: 'Deliver')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getTotalClient() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('userRole', isEqualTo: 'Client')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getTotalOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<OrderModel> getOrderPendingFirstTotal(String userId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return FirebaseFirestore.instance
        .collection('orders')
        .orderBy("createdAt", descending: true)
        .where(
          'deliverRef',
          isEqualTo: FirebaseFirestore.instance.collection('users').doc(userId),
        )
        .where('paymentStatus', isEqualTo: "Pending")
        /*  .where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          isLessThan: Timestamp.fromDate(endOfDay),
        ) */
        .limit(1)
        .snapshots()
        .map((snapshot) {
          return OrderModel.fromSnapshot(snapshot.docs.first);
        });
  }

  Stream<List<OrderModel>> getOrdersFinishLists(String userId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return FirebaseFirestore.instance
        .collection('orders')
        .orderBy("createdAt", descending: true)
        .where('paymentStatus', isEqualTo: "Completed")
        /*  .where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          isLessThan: Timestamp.fromDate(endOfDay),
        ) */
        .limit(5)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList(),
        );
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

  Stream<int> getOrderFinishTotal(String userId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where(
          'deliverRef',
          isEqualTo: FirebaseFirestore.instance.collection('users').doc(userId),
        )
        .where('status', isEqualTo: "completed")
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return 0;

          return snapshot.docs.length;
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

  void _getClientInfo(String userId) async {
    final firebase = FirebaseFirestore.instance;
    final data = await firebase.collection("users").doc(userId).get();
    if (data.exists) {
      final client = UserModel.fromSnapshot(data);
      setState(() {
        clientInfo = client;
      });
    } else {
      print('No data');
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 140,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(57, 15, 89, 146),
                      Color(0xFFFE9003),
                    ],
                    begin: Alignment.centerLeft,
                  ),
                  // color: ,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          spacing: 20,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                TextCustom(
                                  TheText: "Revenu Total",
                                  TheTextSize: 25,
                                  TheTextFontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StreamBuilder(
                                  stream: getBalanceTotale(
                                  ),
                                  builder: (context, asyncSnapshot) {
                                    if (!asyncSnapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }

                                    return Row(
                                      children: [
                                        TextCustom(
                                          TheText: "${asyncSnapshot.data} F",
                                          TheTextSize: 20,
                                          TheTextFontWeight: FontWeight.normal,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              child: Center(
                                child: Icon(
                                  Icons.payments,
                                  color: ColorApp.tPrimaryColor,
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ColorApp.tDarkTextColor,
                              ),
                            ),
                          ],
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
                        color: THelperFunctions.isDarkMode(context)
                            ? Color.fromARGB(19, 255, 25, 0)
                            : Color(0x15ff4332),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            StreamBuilder(
                              stream: getTotalClient(),
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
                              TheText: "Total Clients",
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
                        color: THelperFunctions.isDarkMode(context)
                            ? Color.fromARGB(21, 108, 186, 246)
                            : Color(0x1704365b),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            StreamBuilder(
                              stream: getTotalDeliver(),
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
                              TheText: "Total livreurs",
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
                        color: Color(0x1a66b949),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            StreamBuilder(
                              stream: getTotalOrders(),
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
                              TheText: "Total commandes",
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
                        color: Color.fromARGB(255, 250, 167, 58),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            StreamBuilder(
                              stream: getTotalDeliverAvailable(),
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
                              TheText: "Total Livreur Disponible",
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
                            TextCustom(
                              TheText: "0 F",
                              TheTextSize: 14,
                              TheTextFontWeight: FontWeight.bold,
                              TheTextColor: ColorApp.tBlackColor,
                            ),
                            SizedBox(height: 10),
                            TextCustom(
                              TheText: "Gains journaliers",
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
                              stream: getOrderFinishTodayTotal(
                                FirebaseAuth.instance.currentUser!.uid,
                              ),
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
                              stream: getOrderPendingTotal(
                                FirebaseAuth.instance.currentUser!.uid,
                              ),
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
                              stream: getOrderFinishTotal(
                                FirebaseAuth.instance.currentUser!.uid,
                              ),
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

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextCustom(
                    TheText: 'Livraison en cours',
                    TheTextSize: 15,
                    TheTextFontWeight: FontWeight.bold,
                    TheTextColor: THelperFunctions.isDarkMode(context)
                        ? ColorApp.tWhiteColor
                        : ColorApp.tBlackColor,
                  ),
                ],
              ),
              SizedBox(height: 10),

              Container(
                width: double.infinity,
                height: 300,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: BoxBorder.all(
                    color: Color.fromARGB(57, 74, 177, 255),
                  ),
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromARGB(57, 74, 177, 255),
                ),
                child: StreamBuilder(
                  stream: getOrderPendingFirstTotal(
                    FirebaseAuth.instance.currentUser!.uid,
                  ),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!asyncSnapshot.hasData) {
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
                                TheText: "Aucune livraison en cours.",
                                TheTextSize: 13,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    final order = asyncSnapshot.data!;
                    // Appeler la fonction seulement une fois
                    if (!_hasFetchedClientInfo) {
                      _hasFetchedClientInfo = true;
                      _getClientInfo(
                        order.userRef!.id,
                      ); // <-- récupère les infos du client
                    }

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              TheText: DateFormat(
                                'd/M/y - H:m',
                              ).format(order.createdAt.toDate()),
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
                                    TheText: order.status,
                                    TheTextSize: 12,
                                    TheTextFontWeight: FontWeight.bold,
                                    TheTextColor: ColorApp.tsecondaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              TheText: clientInfo.fullName,
                              TheTextSize: 13,
                              TheTextFontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              TheText: "# ${order.orderId}",
                              TheTextSize: 13,
                              TheTextFontWeight: FontWeight.normal,
                            ),
                            TextCustom(
                              TheText: "${order.amount.toInt()} F",
                              TheTextSize: 13,
                              TheTextFontWeight: FontWeight.normal,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              TheText:
                                  "Distance: ${order.distance.toStringAsFixed(2)} Km",
                              TheTextSize: 13,
                              TheTextFontWeight: FontWeight.normal,
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Color.fromARGB(57, 74, 177, 255),
                                  ),
                                  child: Icon(
                                    Icons.location_on,
                                    color: THelperFunctions.isDarkMode(context)
                                        ? ColorApp.tWhiteColor
                                        : ColorApp.tBlackColor,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        TextCustom(
                                          TheText: "Point de retrait",
                                          TheTextSize: 13,
                                          TheTextFontWeight: FontWeight.bold,
                                          TheTextColor:
                                              THelperFunctions.isDarkMode(
                                                context,
                                              )
                                              ? ColorApp.tWhiteColor
                                              : ColorApp.tBlackColor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: TextCustom(
                                                TheText:
                                                    "${order.withdrawalPoint.address}",
                                                TheTextSize: 13,
                                                TheTextFontWeight:
                                                    FontWeight.normal,
                                                TheTextMaxLines: 5,
                                                TheTextColor:
                                                    THelperFunctions.isDarkMode(
                                                      context,
                                                    )
                                                    ? ColorApp.tWhiteColor
                                                    : ColorApp.tBlackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () async {
                                    final phoneNumber =
                                        "tel:+229${order.numeroWithdrawal}"; // <-- ton numéro ici
                                    final Uri phoneUri = Uri.parse(phoneNumber);

                                    if (await canLaunchUrl(phoneUri)) {
                                      await launchUrl(phoneUri);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Impossible de passer l\'appel',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Icon(
                                    Icons.phone_android,
                                    color: THelperFunctions.isDarkMode(context)
                                        ? ColorApp.tWhiteColor
                                        : ColorApp.tBlackColor,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Color.fromARGB(57, 74, 177, 255),
                                  ),
                                  child: Icon(
                                    Icons.location_on,
                                    color: THelperFunctions.isDarkMode(context)
                                        ? ColorApp.tWhiteColor
                                        : ColorApp.tBlackColor,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        TextCustom(
                                          TheText: "Point de destination",
                                          TheTextSize: 13,
                                          TheTextFontWeight: FontWeight.bold,
                                          TheTextColor:
                                              THelperFunctions.isDarkMode(
                                                context,
                                              )
                                              ? ColorApp.tWhiteColor
                                              : ColorApp.tBlackColor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: TextCustom(
                                                TheText:
                                                    "${order.destinationLocation.address}",
                                                TheTextSize: 13,
                                                TheTextFontWeight:
                                                    FontWeight.normal,
                                                TheTextMaxLines: 5,
                                                TheTextColor:
                                                    THelperFunctions.isDarkMode(
                                                      context,
                                                    )
                                                    ? ColorApp.tWhiteColor
                                                    : ColorApp.tBlackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () async {
                                    final phoneNumber =
                                        "tel:+229${clientInfo.phoneNumber}"; // <-- ton numéro ici
                                    final Uri phoneUri = Uri.parse(phoneNumber);

                                    if (await canLaunchUrl(phoneUri)) {
                                      await launchUrl(phoneUri);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Impossible de passer l\'appel',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Icon(
                                    Icons.phone_android,
                                    color: THelperFunctions.isDarkMode(context)
                                        ? ColorApp.tWhiteColor
                                        : ColorApp.tBlackColor,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextCustom(
                    TheText: 'Livraison récentes',
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
                stream: getOrdersFinishLists(
                  FirebaseAuth.instance.currentUser!.uid,
                ),
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
                      return Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        TheTextColor: ColorApp.tsecondaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                stream: getTransactions(FirebaseAuth.instance.currentUser!.uid),
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
