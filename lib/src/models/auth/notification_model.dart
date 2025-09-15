import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class NotificationModel {
  String? uid;
  DocumentReference? senderRef;
  DocumentReference? receiverRef;
  String title;
  String message;
  String type;
  bool isRead;
  Timestamp createdAt;

  NotificationModel({
     this.uid,
    required this.senderRef,
    required this.receiverRef,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  /// Empty Helper Function
  static NotificationModel empty() => NotificationModel(
    uid: "",
    senderRef: null,
    receiverRef: null,
    title: "",
    message: "",
    type: "",
    isRead: false,
    createdAt: Timestamp.now(),
  );

  /// Convert model to Json structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'senderRef': senderRef,
      'receiverRef': receiverRef,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }

  /// Map Json oriented document snapshot from Firebase to UserModel
  factory NotificationModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;
      print(document.data()!);
      // Map JSON Record to the Model
      return NotificationModel(
        uid: document.id,
        senderRef: data['senderRef'] as DocumentReference?,
        receiverRef: data['receiverRef'] as DocumentReference?,
        title: data['title'] ?? '',
        message: data['message'] ?? '',
        type: data['type'] ?? "",
        isRead: data['isRead'] ?? false,
        createdAt: data['createdAt'] as Timestamp,
      );
    } else {
      return NotificationModel.empty();
    }
    
  }
}
