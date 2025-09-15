import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/constants/sizes.dart';
import 'package:smart_admin/src/models/transactions/transaction_model.dart';
import 'package:smart_admin/src/screens/tabs.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:text_custom/text_custom.dart';
import 'package:intl/intl.dart';

class GainScreen extends StatefulWidget {
  const GainScreen({super.key});

  @override
  State<GainScreen> createState() => _GainScreenState();
}

class _GainScreenState extends State<GainScreen> {
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

  Stream<double> getUserBalance(String userId) {
    return FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: userId)
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
            }
          }

          return totalPayments - totalWithdrawals;
        });
  }

  Stream<double> getWithdrawalsBalance(String userId) {
    return FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: userId)
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
            }
          }

          return totalWithdrawals;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.offAll(() => TabsScreen(initialIndex: 3)),
          icon: Icon(
            LineAwesomeIcons.angle_left_solid,
            color: THelperFunctions.isDarkMode(context)
                ? ColorApp.tWhiteColor
                : ColorApp.tBlackColor,
          ),
        ),
        title: Text(
          'Gains',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        actions: [
          // IconButton(onPressed: () =>(), icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 214, 140, 107),
                      const Color.fromARGB(255, 253, 121, 64),
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
                                  TheText: "Gains disponible",
                                  TheTextSize: 25,
                                  TheTextFontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StreamBuilder(
                                  stream: getUserBalance(
                                    FirebaseAuth.instance.currentUser!.uid,
                                  ),
                                  builder: (context, asyncSnapshot) {
                                    if (!asyncSnapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }

                                    return Row(
                                      children: [
                                        TextCustom(
                                          TheText: "${asyncSnapshot.data} FCFA",
                                          TheTextSize: 20,
                                          TheTextFontWeight: FontWeight.normal,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: ColorApp.tPrimaryColor,
                                  ),
                                  child: Center(
                                    child: TextCustom(
                                      TheText: "Effectuer un retrait",
                                      TheTextSize: 13,
                                      TheTextFontWeight: FontWeight.bold,
                                    ),
                                  ),
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
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextCustom(
                    TheText: "Resumé des gains",
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
                height: 130,
                child: Row(
                  children: [
                    Container(
                      width: 160,
                      height: 100,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 1, color: Colors.green),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.check_box, color: Colors.green),
                          StreamBuilder(
                            stream: getUserBalance(
                              FirebaseAuth.instance.currentUser!.uid,
                            ),
                            builder: (context, asyncSnapshot) {
                              if (!asyncSnapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              return TextCustom(
                                TheText: "${asyncSnapshot.data} F",
                                TheTextSize: 25,
                                TheTextFontWeight: FontWeight.bold,
                                TheTextColor: Colors.green,
                              );
                            },
                          ),
                          TextCustom(
                            TheText: "Disponibles",
                            TheTextSize: 15,
                            TheTextFontWeight: FontWeight.normal,
                            TheTextColor: Colors.green,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      width: 160,
                      height: 100,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 1, color: Colors.red),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.account_balance_wallet, color: Colors.red),
                          StreamBuilder(
                            stream: getWithdrawalsBalance(
                              FirebaseAuth.instance.currentUser!.uid,
                            ),
                            builder: (context, asyncSnapshot) {
                              if (!asyncSnapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              return TextCustom(
                                TheText: "${asyncSnapshot.data} F",
                                TheTextSize: 25,
                                TheTextFontWeight: FontWeight.bold,
                                TheTextColor: Colors.red,
                              );
                            },
                          ),
                          TextCustom(
                            TheText: "Retraits",
                            TheTextSize: 15,
                            TheTextFontWeight: FontWeight.normal,
                            TheTextColor: Colors.red,
                          ),
                        ],
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
                    TheText: "Historique des transactions",
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
                    return Center(
                      child: TextCustom(
                        TheText: 'Aucune transaction ',
                        TheTextSize: 13,
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
                          borderRadius: BorderRadius.circular(12),
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
