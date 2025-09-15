import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/controllers/OrdersController.dart';
import 'package:smart_admin/src/models/auth/notification_model.dart';
import 'package:smart_admin/src/models/order_model.dart';
import 'package:smart_admin/src/repository/authentification_repository.dart';
import 'package:smart_admin/src/screens/chat/chat_screen.dart';
import 'package:smart_admin/src/screens/orders/order_detail.dart';
import 'package:smart_admin/src/screens/orders/orders.dart';
import 'package:smart_admin/src/screens/orders/see_deliver_position.dart';
import 'package:smart_admin/src/screens/tabs.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/texts/button_custom.dart';
import 'package:smart_admin/src/utils/texts/button_custom_outlined.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:smart_admin/src/screens/orders/TrackDeliveryPage.dart';

final ordersController = Get.put(Orderscontroller());

class OrderStep extends StatefulWidget {
  const OrderStep({
    super.key,
    required this.status,
    required this.orderId,
    required this.amount,
    required this.carId,
    required this.userCreatedId,
  });

  final String status;
  final String carId;
  final String orderId;
  final String userCreatedId;
  final double amount;

  @override
  State<OrderStep> createState() => _OrderStepState();
}

class _OrderStepState extends State<OrderStep> {
  final firebase = FirebaseFirestore.instance;
  OrderModel orderData = OrderModel.empty();
  int currentStep = 0;
  var user = {};
  var clientInfo = {};
  String userName = "";
  String userEmail = "";
  String userPhone = "";

  void _getUserInfo() async {
    final auth = FirebaseAuth.instance.currentUser!;
    final data = await AuthentificationRepository.instance.getUserInfo(
      auth.uid,
    );
    if (data.isNotEmpty) {
      setState(() {
        user = data;
        userName = user['fullName'];
        userEmail = user['email'];
      });
    } else {
      print('No data');
    }
  }

  void _getClientInfo() async {
    final data = await AuthentificationRepository.instance.getUserInfo(
      widget.userCreatedId,
    );
    if (data.isNotEmpty) {
      setState(() {
        clientInfo = data;
      });
    } else {
      print('No data');
    }
  }

  void _fetchOrderDetails() async {
    final data = await firebase.collection('orders').doc(widget.orderId).get();

    if (data.exists) {
      final order = OrderModel.fromSnapshot(data);
      setState(() {
        orderData = order;
      });
    } else {
      print('No data');
    }
  }

  void callback(response, context) async {
    switch (response['status']) {
      case PAYMENT_CANCELLED:
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Paiement annulé avec succès.')));
        debugPrint(PAYMENT_CANCELLED);
        break;

      case PAYMENT_INIT:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Paiement initialisé.')));
        debugPrint(PAYMENT_INIT);
        break;

      case PENDING_PAYMENT:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Paiement en attente.')));
        debugPrint(PENDING_PAYMENT);
        break;

      case PAYMENT_SUCCESS:
        Navigator.pop(context);
        await _updateOrderStatusAfterPayment('finish');
        break;

      default:
        debugPrint(UNKNOWN_EVENT);
        break;
    }
  }

  KKiaPay buildKkiaPay() {
    return KKiaPay(
      amount: widget.amount.toInt(), //
      countries: ["BJ", "CI", "SN", "TG"], //
      phone: "22961000000", //
      name: userName, //
      email: userEmail, //
      reason: 'Paiement de la Course #${widget.orderId}', //
      data: 'Fake data', //
      sandbox: true, //
      apikey: "c6026b10652411efbf02478c5adba4b8", //
      callback: callback, //
      theme: defaultTheme, // Ex : "#222F5A",
      partnerId: 'AxXxXXxId', //
      paymentMethods: ["momo", "card"], //
    );
  }

  int _getStepFromStatus(String status) {
    switch (status.toLowerCase()) {
      case 'neworder':
        return 0;
      case 'assigned':
        return 1;
      case 'accepted':
        return 2;
      case 'pending':
        return 3;
      case 'delivered':
        return 4;
      case 'paymentstep':
        return 5;
      case 'finish':
        return 6;
      case 'cancelled':
        return 7;
      case 'refused':
        return 8;
      default:
        return 0;
    }
  }

  String _getStatusFromStep(int step) {
    switch (step) {
      case 0:
        return 'neworder';
      case 1:
        return 'assigned';
      case 2:
        return 'accepted';
      case 3:
        return 'pending';
      case 4:
        return 'delivered';
      case 5:
        return 'paymentstep';
      case 6:
        return 'finish';
      case 7:
        return 'cancelled';
      case 8:
        return 'refused';
      default:
        return 'neworder';
    }
  }

  void _onContinueStep() {
    if (currentStep < 6) {
      setState(() {
        currentStep++;
      });

      final newStatus = _getStatusFromStep(currentStep);
      _updateOrderStatus(newStatus);
      print("Nouveau statut : $newStatus");
      // tu peux ici mettre à jour le Firestore si tu le souhaites
    }
  }

  void _onCancelStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1;
      });
    }
  }

  void _onStopStep(int value) {
    /*  if (currentStep > 0) {
      setState(() {
        currentStep = value;
      });
    } */
  }

  Future<void> _updateOrderStatus(String newStatus) async {
    final firebase = FirebaseFirestore.instance;

    try {
      await firebase.collection('orders').doc(widget.orderId).update({
        'status': newStatus,
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Statut mis à jour : $newStatus')));
    } catch (e) {
      print('Erreur de mise à jour du statut: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la mise à jour')),
      );
    }
  }

  Future<void> _updateStatusAfterClientPayment(String newStatus) async {
    final firebase = FirebaseFirestore.instance;

    try {
      await firebase.collection('orders').doc(widget.orderId).update({
        'status': newStatus,
      });

      final notification = NotificationModel(
        senderRef: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid),
        receiverRef: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userCreatedId),
        title: 'Confirmation de Paiement',
        message: "Votre paiement a été confirmé avec succès.",
        type: "Location",
        isRead: false,
        createdAt: Timestamp.now(),
      );

      await FirebaseFirestore.instance
          .collection('notifications')
          .add(notification.toJson());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Statut mis à jour : $newStatus')));
    } catch (e) {
      print('Erreur de mise à jour du statut: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la mise à jour')),
      );
    }
  }

  List<Timestamp> reserves = [];

  Future<void> _updateOrderStatusAfterPayment(String newStatus) async {
    final firebase = FirebaseFirestore.instance;

    try {
      await firebase.collection('orders').doc(widget.orderId).update({
        'status': newStatus,
        'paymentStatus': 'Completed',
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Paiement effectué avec succès.')));
    } catch (e) {
      print('Erreur de mise à jour du statut: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la mise à jour')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _getClientInfo();
    _fetchOrderDetails();
    print(widget.status);
    print(_getStepFromStatus(widget.status));
    // currentStep = _getStepFromStatus(widget.status);
  }

  Widget controlsBuilder(context, details) {
    return Row(
      children: [
        ElevatedButton(onPressed: details.onStepCancel, child: Text('Retour')),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: details.onStepContinue,
          child: Text('Suivant'),
        ),
      ],
    );
  }

  List<Step> getSteps(String status, int currentStep) {
    return [
      Step(
        title: const Text('Nouvelle course'),
        content: Column(
          children: [
            Text(
              'Votre avez une nouvelle commande de ${clientInfo['fullName']} .',
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ButtonCustomOutlined(
                    onPressed: () async {
                      Get.to(
                        () => OrderDetailScreen(
                          startLocation: orderData.withdrawalPoint,
                          endLocation: orderData.destinationLocation,
                          userCreatedId: orderData.userRef!.id,
                          orderId: orderData.uid!,
                        ),
                      );
                    },
                    text: 'Voir les Détails',
                    textSize: 14,
                    buttonWith: double.infinity,
                    buttonPaddingVertical: 5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ButtonCustom(
                    buttonBackgroundColor: Colors.red,
                    onPressed: () async {
                      Get.to(
                        () => SeeDeliverPositionScreen(
                          startLocation: orderData.withdrawalPoint,
                          orderId: orderData.uid!,
                          clientId: orderData.userRef!.id,
                        ),
                      );
                    },
                    text: 'Voir livreur(s) proches.',
                    textSize: 14,
                    buttonWith: double.infinity,
                    buttonPaddingVertical: 5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ButtonCustomOutlined(
                    onPressed: () async {
                      Get.to(
                        () => ChatScreen(
                          receiverID: orderData.userRef!.id,
                          receiverEmail: clientInfo['email'],
                        ),
                      );
                    },
                    text: 'Discuter avec le client',
                    textSize: 14,
                    buttonWith: double.infinity,
                    buttonPaddingVertical: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
        isActive: currentStep == 0,
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Assignation de la commande'),
        content: Column(
          children: [
            Text("La course est en cours d'acceptation par le livreur."),
            SizedBox(height: 10),
            ButtonCustomOutlined(
              onPressed: () async {
                Get.to(
                  () => OrderDetailScreen(
                    startLocation: orderData.withdrawalPoint,
                    endLocation: orderData.destinationLocation,
                    userCreatedId: orderData.userRef!.id,
                    orderId: orderData.uid!,
                  ),
                );
              },
              text: 'Voir les Détails',
              textSize: 14,
              buttonWith: double.infinity,
              buttonPaddingVertical: 5,
            ),
            SizedBox(height: 10),
            ButtonCustomOutlined(
              onPressed: () async {
                Get.to(
                  () => SeeDeliverPositionScreen(
                    startLocation: orderData.withdrawalPoint,
                    orderId: orderData.uid!,
                    clientId: orderData.userRef!.id,
                  ),
                );
              },
              text: 'Desassigner la course',
              textSize: 14,
              buttonWith: double.infinity,
              buttonPaddingVertical: 5,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ButtonCustomOutlined(
                    onPressed: () async {
                      Get.to(
                        () => ChatScreen(
                          receiverID: orderData.userRef!.id,
                          receiverEmail: clientInfo['email'],
                        ),
                      );
                    },
                    text: 'Discuter avec le client',
                    textSize: 14,
                    buttonWith: double.infinity,
                    buttonPaddingVertical: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
        isActive: currentStep == 1,
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Acceptation de la commande'),
        content: const Text("La Livreur vient d'accepter la course."),
        isActive: currentStep == 2,
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Livraison en cours'),
        content: Column(
          children: [
            Text("La Livreur est en train de livrer le colis."),
            SizedBox(height: 20),
            Row(
              spacing: 2,
              children: [
                Expanded(
                  child: ButtonCustomOutlined(
                    onPressed: () async {
                      Get.to(
                        () => TrackDeliveryPage(
                          orderId: orderData.uid!,
                          googleApiKey:
                              "AIzaSyA1Y_y0JkVgT9OKiBo7G_GXcIeCGHOMii8",
                        ),
                      );
                    },
                    text: 'Voir Map',
                    textSize: 14,
                    buttonWith: 80,
                    buttonPaddingVertical: 5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ButtonCustomOutlined(
                    onPressed: () async {
                      Get.to(
                        () => ChatScreen(
                          receiverID: orderData.userRef!.id,
                          receiverEmail: clientInfo['email'],
                        ),
                      );
                    },
                    text: 'Discuter avec le client',
                    textSize: 14,
                    buttonWith: double.infinity,
                    buttonPaddingVertical: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
        isActive: currentStep == 3,
        state: currentStep > 3 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Réception de la commande'),
        content: Column(
          children: [
            Text("Colis livré avec succès."),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ButtonCustomOutlined(
                    onPressed: () async {
                      Get.to(
                        () => ChatScreen(
                          receiverID: orderData.userRef!.id,
                          receiverEmail: clientInfo['email'],
                        ),
                      );
                    },
                    text: 'Discuter avec le client',
                    textSize: 14,
                    buttonWith: double.infinity,
                    buttonPaddingVertical: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
        isActive: currentStep == 4,
        state: currentStep > 4 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Paiement de la course'),
        content: Column(
          children: [
            Text('La course est en cours de paiement.'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ButtonCustomOutlined(
                    onPressed: () async {
                      Get.to(
                        () => ChatScreen(
                          receiverID: orderData.userRef!.id,
                          receiverEmail: clientInfo['email'],
                        ),
                      );
                    },
                    text: 'Discuter avec le client',
                    textSize: 14,
                    buttonWith: double.infinity,
                    buttonPaddingVertical: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
        isActive: currentStep == 5,
        state: currentStep == 5 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Course terminée'),
        content: Column(
          children: [
            Text('La course est terminée'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ButtonCustomOutlined(
                    onPressed: () async {
                      Get.to(
                        () => ChatScreen(
                          receiverID: orderData.userRef!.id,
                          receiverEmail: clientInfo['email'],
                        ),
                      );
                    },
                    text: 'Discuter avec le client',
                    textSize: 14,
                    buttonWith: double.infinity,
                    buttonPaddingVertical: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
        isActive: currentStep == 6,
        state: currentStep == 6 ? StepState.complete : StepState.indexed,
      ),

      /*  if (widget.status == 'cancelled')
        Step(
          title: const Text('Course annulée'),
          content: const Text('Votre Course a été annulée.'),
          isActive: currentStep == 5,
          state: currentStep == 5 ? StepState.error : StepState.error,
        ), */

      /*  if (widget.status == 'refused')
        Step(
          title: const Text('Course refusée'),
          content: const Text(
            'Votre Course a été refusée par le propriétaire.',
          ),
          isActive: currentStep == 6,
          state: currentStep == 6 ? StepState.error : StepState.error,
        ), */
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => TabsScreen(initialIndex: 1));
          },
          icon: Icon(
            LineAwesomeIcons.angle_left_solid,
            color: THelperFunctions.isDarkMode(context)
                ? ColorApp.tWhiteColor
                : ColorApp.tBlackColor,
          ),
        ),
        centerTitle: true,
        title: TextCustom(
          TheText: "Suivi de la commande",
          TheTextSize: 14,
          TheTextFontWeight: FontWeight.bold,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Course refusée"));
          }

          final status = snapshot.data!['status'];
          final currentStep = _getStepFromStatus(status);

          if (status == "refused") {
            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  TextCustom(
                    TheText: "Course refusée",
                    TheTextSize: 15,
                    TheTextFontWeight: FontWeight.bold,
                    TheTextColor: ColorApp.tsecondaryColor,
                  ),
                  SizedBox(width: 10),
                  Text("Votre Course a été refusée par l'admin."),
                ],
              ),
            );
          }
          if (status == "cancelled") {
            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  TextCustom(
                    TheText: "Course annulée",
                    TheTextSize: 15,
                    TheTextFontWeight: FontWeight.bold,
                    TheTextColor: ColorApp.tsecondaryColor,
                  ),
                  SizedBox(width: 10),
                  Text('Votre Course a été annulée.'),
                ],
              ),
            );
          }
          return Stepper(
            currentStep: currentStep,
            onStepTapped: _onStopStep,
            //onStepCancel: _onCancelStep,
            //onStepContinue: _onContinueStep,
            controlsBuilder: (_, __) => const SizedBox.shrink(),
            steps: getSteps(status, currentStep),
          );
        },
      ),
    );
  }
}
