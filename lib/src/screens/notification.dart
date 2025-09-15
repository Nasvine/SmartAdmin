import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/constants/sizes.dart';
import 'package:smart_admin/src/models/auth/notification_model.dart';
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

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Stream<List<NotificationModel>> getNotifications(String userId) {
    return FirebaseFirestore.instance
        .collection('notifications')
        .where(
          'receiverRef',
          isEqualTo: FirebaseFirestore.instance.collection("users").doc(userId),
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromSnapshot(doc))
              .toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.offAll(() => TabsScreen(initialIndex: 0)),
          icon: Icon(
            LineAwesomeIcons.angle_left_solid,
            color: THelperFunctions.isDarkMode(context)
                ? ColorApp.tWhiteColor
                : ColorApp.tBlackColor,
          ),
        ),
        title: Text(
          'Notifications',
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
              StreamBuilder(
                stream: getNotifications(
                  FirebaseAuth.instance.currentUser!.uid,
                ),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
                    return Center(
                      child: TextCustom(
                        TheText: 'Aucune notification. ',
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
                      final notifItem = transaction[index];
                      return Container(
                        height: 120,
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom:5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (notifItem.type == "Location")
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: ColorApp.tSombreColor,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.delivery_dining_outlined,
                                        color: ColorApp.tPrimaryColor,
                                      ),
                                    ),
                                  ),
                                if (notifItem.type == "Chat")
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: ColorApp.tSombreColor,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.chat,
                                        color: ColorApp.tPrimaryColor,
                                      ),
                                    ),
                                  ),
                                if (notifItem.type == "Platform")
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: ColorApp.tSombreColor,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.admin_panel_settings_sharp,
                                        color: ColorApp.tPrimaryColor,
                                      ),
                                    ),
                                  ),
                                if (notifItem.type == "Payment")
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: ColorApp.tSombreColor,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.payment,
                                        color: ColorApp.tPrimaryColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 240,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        TheText: notifItem.title,
                                        TheTextSize: 15,
                                        TheTextColor: Colors.black,
                                        TheTextFontWeight: FontWeight.bold,
                                      ),
                                      Text(
                                        notifItem.message,
                                        style: TextStyle(color: Colors.black),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
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
