import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum OrderStatus {
  neworder,
  pending,
  confirmed,
  inpayment,
  finish,
  cancelled,
  refused,
}

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;

  Map<String, dynamic> toMap() {
    return {'latitude': latitude, 'longitude': longitude, 'address': address};
  }

  factory PlaceLocation.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const PlaceLocation(latitude: 0.0, longitude: 0.0, address: '');
    }

    return PlaceLocation(
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      address: map['address'] ?? '',
    );
  }
}

class OrderModel {
  final String? uid;
  final String orderId;
  final String deliveryType;
  final DocumentReference? userRef;
  final DocumentReference? managerRef;
  final DocumentReference? deliverRef;
  final PlaceLocation withdrawalPoint;
  final PlaceLocation destinationLocation;
  final PlaceLocation deliverLocation;
  final bool isDriverAssigned;
  final Timestamp? timeOfAllocation;
  final Timestamp? startTime;
  final Timestamp? endTime;
  final String status;
  final String message;
  final int numeroWithdrawal;
  final double distance;
  final double amount;
  final double purchasePrice;
  final String? paymentMethod;
  final double totalPrice;
  final String reasonForCancellation;
  final String paymentStatus;
  final Timestamp createdAt;
  final String? clientReviews;
  final int clientRating;
  final String? deliverReviews;
  final int deliverRating;

  OrderModel({
    this.uid,
    required this.orderId,
    required this.deliveryType,
    this.userRef,
    this.managerRef,
    this.deliverRef,
    required this.withdrawalPoint,
    required this.destinationLocation,
    required this.deliverLocation,
    required this.isDriverAssigned,
    this.timeOfAllocation,
    this.startTime,
    this.endTime,
    required this.status,
    required this.message,
    required this.numeroWithdrawal,
    required this.distance,
    required this.amount,
    required this.purchasePrice,
    this.paymentMethod,
    required this.totalPrice,
    required this.reasonForCancellation,
    required this.paymentStatus,
    required this.createdAt,
    this.clientReviews,
    this.clientRating = 0,
    this.deliverReviews,
    this.deliverRating = 0,
  });

  /// Empty Helper Function
  static OrderModel empty() => OrderModel(
    uid: "",
    orderId: "",
    deliveryType: "",
    withdrawalPoint: PlaceLocation(latitude: 0, longitude: 0, address: ""),
    destinationLocation: PlaceLocation(latitude: 0, longitude: 0, address: ""),
    deliverLocation: PlaceLocation(latitude: 0, longitude: 0, address: ""),
    isDriverAssigned: false,
    status: "",
    message: "",
    numeroWithdrawal: 0,
    distance: 0,
    amount: 0,
    purchasePrice: 0,
    totalPrice: 0,
    reasonForCancellation: "",
    paymentStatus: "",
    createdAt: Timestamp.now(),
  );

  /// Convert model to Json structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'orderId':orderId ,
      'userRef':userRef ,
      'managerRef':managerRef ,
      'deliverRef':deliverRef ,
      'deliveryType':deliveryType ,
      'withdrawalPoint':withdrawalPoint.toMap() ,
      'destinationLocation':destinationLocation.toMap() ,
      'deliverLocation':deliverLocation.toMap() ,
      'isDriverAssigned':isDriverAssigned ,
      'status':status ,
      'message':message ,
      'numeroWithdrawal':numeroWithdrawal ,
      'distance':distance ,
      'amount':amount ,
      'purchasePrice':purchasePrice ,
      'totalPrice':totalPrice ,
      'reasonForCancellation':reasonForCancellation ,
      'paymentStatus':paymentStatus ,
      'createdAt':createdAt ,
    };
  }

  /// Map Json oriented document snapshot from Firebase to UserModel
  factory OrderModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;

      // Map JSON Record to the Model
      return OrderModel(
        uid: document.id,
        orderId: data['orderId'] ?? "0176346767",
        userRef: data['userRef'] as DocumentReference?,
        managerRef: data['managerRef'] as DocumentReference?,
        deliverRef: data['deliverRef'] as DocumentReference?,
        deliveryType: data['deliveryType'] ?? "",
        withdrawalPoint: PlaceLocation.fromMap(data['withdrawalPoint']),
        destinationLocation: PlaceLocation.fromMap(data['destinationLocation']),
        deliverLocation: PlaceLocation.fromMap(data['deliverLocation']),
        isDriverAssigned: data['isDriverAssigned'] ?? false,
        status: data['status'] ?? "NewOrder",
        message: data['message'] ?? "",
        numeroWithdrawal: data['numeroWithdrawal'] ?? 09999983774,
        distance: data['distance'] ?? 0,
        amount: data['amount'] ?? 0,
        clientRating: data['clientRating'] ?? 3,
        deliverRating: data['deliverRating'] ?? 0,
        purchasePrice: data['purchasePrice'] ?? 0,
        totalPrice: data['totalPrice'] ?? 0,
        clientReviews: data['clientReviews'] ?? "",
        deliverReviews: data['deliverReviews'] ?? "",
        reasonForCancellation: data['reasonForCancellation'] ?? "",
        paymentStatus: data['paymentStatus'] ?? "Pending",
        createdAt: data['createdAt'] ?? Timestamp.now(),
      );
    } else {
      return OrderModel.empty();
    }
  }
}
