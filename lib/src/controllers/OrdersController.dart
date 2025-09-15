import 'package:smart_admin/src/constants/action_type_enum.dart';
import 'package:smart_admin/src/constants/images.dart';
import 'package:smart_admin/src/constants/order_enum.dart';
import 'package:smart_admin/src/constants/payment_status_enum.dart';
import 'package:smart_admin/src/models/order_model.dart';
import 'package:smart_admin/src/repository/authentification_repository.dart';
import 'package:smart_admin/src/repository/order_repository.dart';
import 'package:smart_admin/src/screens/orders/orders.dart';
import 'package:smart_admin/src/utils/loaders/loaders.dart';
import 'package:smart_admin/src/utils/popups/full_screen_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:math';

class Orderscontroller extends GetxController {
  static Orderscontroller get instance => Get.find();

  final _orderRepository = Get.put(OrderRepository());
  final isloading = false.obs;
  RxList<OrderModel> allOrders = <OrderModel>[].obs;
  RxList<OrderModel> featuredOrders = <OrderModel>[].obs;
  GlobalKey<FormState> orderformKey = GlobalKey<FormState>();
  final clientPhone = TextEditingController();
  final typeLocation = TextEditingController();
  RxList<Timestamp> reservationDates = <Timestamp>[].obs;
  RxList<Timestamp> blackedOutDates = <Timestamp>[].obs;

  int priceTotal = 0;

  // Date Choise

  final selectedDate = ''.obs;
  final dateCount = 0.0.obs;
  final range = ''.obs;
  final rangeCount = ''.obs;

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onInit() {
    //fetchOrders();
    super.onInit();
  }

  Future<String> getCarLink(String uid) async {
    try {
      /* CarModel? car = await CarsController.instance.getCarById(uid);

      if (car == null) {
        print("🚫 Aucune voiture trouvée pour l'uid: $uid");
        return "";
      }

      return car.link; */
      return "";
    } catch (e) {
      print("❌ Erreur lors de la récupération de la voiture : $e");
      return "";
    }
  }

  Future<int> getCarPrice(String uid) async {
    try {
      /*  CarModel? car = await CarsController.instance.getCarById(uid);

      if (car == null) {
        print("🚫 Aucune voiture trouvée pour l'uid: $uid");
        return 0;
      } */

      return 2 /* car.pricePerDay */;
    } catch (e) {
      print("❌ Erreur lors de la récupération de la voiture : $e");
      return 0;
    }
  }

  Future<List<Timestamp>> getReservedDatesForCar(String carId) async {
    final firebase = FirebaseFirestore.instance;

    final snapshot = await firebase
        .collection('orders')
        .where('carRef', isEqualTo: firebase.collection('cars').doc(carId))
        .get();
    print('Iciiiiiiiiiiii $snapshot');
    final reservedDates = <Timestamp>[];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      if (data['reservationDates'] != null) {
        final List<dynamic> timestamps = data['reservationDates'];
        reservedDates.addAll(timestamps.map((e) => e as Timestamp));
      }
    }

    return reservedDates;
  }

  Future<void> loadBlackoutDates(String carId) async {
    final dates = await getReservedDatesForCar(carId);
    blackedOutDates.assignAll(dates);
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    print(args);
    if (args.value is PickerDateRange) {
      final startDate = args.value.startDate;
      final endDate = args.value.endDate ?? startDate;
      range.value =
          '${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}';
    } else if (args.value is DateTime) {
      selectedDate.value = DateFormat('dd/MM/yyyy').format(args.value);
    } else if (args.value is List<DateTime>) {
      final dates = args.value as List<DateTime>;
      reservationDates.value = dates.map((d) => Timestamp.fromDate(d)).toList();
      dateCount.value = dates.length.toDouble();
    } else if (args.value is List<PickerDateRange>) {
      rangeCount.value = args.value.length.toString();
    }
  }

  /// -- Load category data
  Future<void> fetchOrders() async {
    try {
      // Show loader while loading Brands
      isloading.value = true;
      // Fetch Cars from data source (Firestore, API, etc.)
      final cars = await _orderRepository.getAllOrders();

      // Update the Brands list
      allOrders.assignAll(cars);
      // Filter featured Brands
      /*  featuredOrders.assignAll(
        // allOrders.where((document) => document.uid.isEmpty).toList(),
      ); */
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Remove loader
      isloading.value = false;
    }
  }

  /// Récupère une voiture depuis une DocumentReference
  Future<OrderModel?> getCarByRef(DocumentReference ref) async {
    try {
      // Vérifie si la voiture est déjà dans la liste
      final id = ref.id;
      final existing = allOrders.firstWhereOrNull((b) => b.uid == id);
      if (existing != null) return existing;

      // Sinon on la récupère depuis Firestore
      final snapshot = await ref
          .withConverter<OrderModel>(
            fromFirestore: (snap, _) => OrderModel.fromSnapshot(snap),
            toFirestore: (car, _) => car.toJson(),
          )
          .get();

      final car = snapshot.data();
      if (car != null) {
        allOrders.add(car); // Mise en cache locale
      }

      return car;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Erreur Voiture', message: e.toString());
      return null;
    }
  }

  Future<OrderModel?> getCarById(String uid) async {
    try {
      // Vérifie si la voiture est déjà dans la liste

      final existing = allOrders.firstWhereOrNull((b) => b.uid == uid);
      if (existing != null) return existing;

      // Reconstitue la référence du document à partir du uid
      final ref = FirebaseFirestore.instance
          .collection('cars') // Remplace par le nom exact de ta collection
          .doc(uid);

      // Sinon on la récupère depuis Firestore
      final snapshot = await ref
          .withConverter<OrderModel>(
            fromFirestore: (snap, _) => OrderModel.fromSnapshot(snap),
            toFirestore: (car, _) => car.toJson(),
          )
          .get();

      final car = snapshot.data();
      if (car != null) {
        allOrders.add(car); // Mise en cache locale
      }

      return car;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Erreur Voiture', message: e.toString());
      return null;
    }
  }

  /// Calculate Reserve price

  int calculateReservePrice(int pricePerDay, int numberOfDays) {
    return pricePerDay * numberOfDays;
  }

  String generateOrderId() {
    final random = Random();
    int number = random.nextInt(1000000); // génère un nombre entre 0 et 999999
    return number.toString().padLeft(6, '0'); // ajoute des zéros si nécessaire
  }
}
