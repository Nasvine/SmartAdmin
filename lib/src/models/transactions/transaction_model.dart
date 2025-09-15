import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String? uid;
  final String userId;
  final String userCreatedId;
  final double amount; // "completed" # ou "pending", "failed"
  final String type; // "payment" ou "withdrawal"
  final String status;
  final Timestamp createdAt;
  final String reference;

  TransactionModel({
     this.uid,
    required this.userId,
    required this.userCreatedId,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.reference,
  });

  static TransactionModel empty() => TransactionModel(
    
    userId: "",
    userCreatedId: "",
    amount: 0,
    type: "",
    status: "",
    createdAt: Timestamp.now(),
    reference: "",
  );

  factory TransactionModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;
      return TransactionModel(
        uid: document.id,
        userId: data['userId'] ?? '',
        userCreatedId: data['userCreatedId'] ?? '',
        amount: data['amount'] ?? '',
        type: data['type'] ?? '',
        status: data['status'] ?? '',
        createdAt: data['createdAt'] ?? '',
        reference: data['reference'] ?? '',
      );
    } else {
      return TransactionModel.empty();
    }
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'userCreatedId': userCreatedId,
    'amount': amount,
    'type': type,
    'status': status,
    'createdAt': createdAt,
    'reference': reference,
  };
}
