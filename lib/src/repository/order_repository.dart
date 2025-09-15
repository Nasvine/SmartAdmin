import 'package:smart_admin/src/exeptions/firebase_exception.dart';
import 'package:smart_admin/src/exeptions/platform_exception.dart';
import 'package:smart_admin/src/models/order_model.dart';
import 'package:smart_admin/src/repository/authentification_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;

  /// Get all categories
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final snapshot = await _db.collection('orders').get();
      final list = snapshot.docs
          .map((document) => OrderModel.fromSnapshot(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      print(
        "------------------------------------------------------------------------dddd---------------------------------",
      );
      print("FirebaseAuthException code: ${e.code}");
      throw TFirebaseException(e.code).message;
    } on TPlatformException catch (e) {
      print(
        "------------------------------------------------------------------------dddd---------------------------------",
      );
      print("TPlatformException code: ${e.code}");
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Add new car
  Future<String> addNewOrder(OrderModel orderData) async {
    try {
      final userId = AuthentificationRepository.instance.authUser!.uid;
      final order = await _db.collection("orders").add(orderData.toJson());
      return order.id;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Add new car
  Future<String> updateCars(OrderModel orderData) async {
    try {
      final userId = AuthentificationRepository.instance.authUser!.uid;
      final car = await _db.collection("cars").add(orderData.toJson());
      return car.id;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}
