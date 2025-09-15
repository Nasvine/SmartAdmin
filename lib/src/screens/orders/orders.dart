import 'package:lottie/lottie.dart';
import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/models/order_model.dart';
import 'package:smart_admin/src/screens/orders/order_step.dart';
import 'package:smart_admin/src/screens/tabs.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';
import 'package:smart_admin/src/utils/widget_theme/custom_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final tabs = OrderStatus.values.map((item) => item.name).toList();
  late List<OrderModel> orders = [];

  Stream<List<OrderModel>> _getOrderList() {
    final firebase = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance.currentUser!;
    return firebase
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((order) => OrderModel.fromSnapshot(order))
              .toList(),
        );
  }

  @override
  void initState() {
    super.initState();
    _getOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.orange.shade100,
                ),
                child: const TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: ColorApp.tsecondaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelColor: ColorApp.tWhiteColor,
                  unselectedLabelColor: ColorApp.tBlackColor,
                  tabs: [
                    Tab(text: "Courses"),
                    Tab(text: "Historiques"),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: StreamBuilder<List<OrderModel>>(
          stream: _getOrderList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      height: 150,
                      width: 150,
                      'assets/images/no_data.json',
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    TextCustom(
                      TheText: "Aucune course trouvée",
                      TheTextSize: 13,
                    ),
                  ],
                ),
              );
            }

            final allOrders = snapshot.data!;

            // Séparation des commandes
            final mesCourses = allOrders
                .where((order) => order.status.toLowerCase() != "completed")
                .toList();

            final historiques = allOrders
                .where((order) => order.status.toLowerCase() == "completed")
                .toList();

            return TabBarView(
              children: [
                // Onglet "Mes courses"
                _buildOrderList(mesCourses),

                // Onglet "Historiques"
                _buildOrderList(historiques),
              ],
            );
          },
        ),
      ),
    );
  }

  // Widget réutilisable pour afficher une liste de commandes
  Widget _buildOrderList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
              const SizedBox(height: 10),
              TextCustom(TheText: "Aucune course trouvée", TheTextSize: 13),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: orders.length,
      itemBuilder: (_, index) {
        final order = orders[index];
        return InkWell(
          onTap: () {
            print(order.orderId);
            Get.to(
              () => OrderStep(
                status: order.status,
                orderId: order.uid!,
                amount: order.amount,
                carId: '',
                userCreatedId: order.userRef!.id,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: ColorApp.tSombreColor),
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Image.asset(
                        'assets/images/Screenshot.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /* 1 */
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              TheText: 'Course: ${order.orderId}',
                              TheTextSize: 13,
                              TheTextFontWeight: FontWeight.bold,
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
                        /* 2 */
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              TheText: 'Date',
                              TheTextSize: 13,
                              TheTextFontWeight: FontWeight.bold,
                            ),
                            Row(
                              spacing: 3,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.date_range_outlined,
                                  size: 16,
                                  color: ColorApp.tsecondaryColor,
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: TextCustom(
                                    TheText: DateFormat(
                                      'd/M/y',
                                    ).format(order.createdAt.toDate()),
                                    TheTextSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              TheText: 'Prix',
                              TheTextSize: 13,
                              TheTextFontWeight: FontWeight.bold,
                            ),
                            Row(
                              spacing: 3,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: TextCustom(
                                    TheText:
                                        "${order.amount.toStringAsFixed(2)} FCFA",
                                    TheTextSize: 12,
                                    TheTextColor: ColorApp.tSecondaryColor,
                                  ),
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
      },
    );
  }
}
