import 'package:cloud_firestore/cloud_firestore.dart';

class WalletModel {
  final DocumentReference? uuid;
  final String userId;
  final double amount;
  final Timestamp createdAt;

  WalletModel({
     this.uuid,
    required this.userId,
    required this.amount,
    required this.createdAt,
  });

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      uuid: null,
      userId: map['userId'],
      amount: map['amount'] ?? 0,
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  static WalletModel empty() =>
      WalletModel(uuid: null,userId: "", amount: 0, createdAt: Timestamp.now());

  factory WalletModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    if (snapshot.data() != null) {
      final data = snapshot.data()!;

      return WalletModel(
        uuid: snapshot.reference,
        userId: data['userId'],
        amount: data['amount'] ?? 0,
        createdAt: data['createdAt'] ?? Timestamp.now(),
      );
    } else {
      return WalletModel.empty();
    }
  }

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'amount': amount, 'createdAt': createdAt};
  }
}
