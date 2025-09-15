import 'package:smart_admin/notification_services.dart';
import 'package:smart_admin/src/models/auth/notification_model.dart';
import 'package:smart_admin/src/models/chat/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser!;

  // List of Owner Car

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  // Send Message

  /* Future<void> sendMessage(String receiverID, message) async {
    // get current User Info
    final String currentUserID = _user.uid;
    final String currentUserEmail = _user.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new message

    MessageModel newMessage = MessageModel(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // construct chat room ID for the two users(sorted to ensure uniqueness )

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // add new message to database

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  } */

  String getChatRoomID(String id1, String id2) {
    final sortedIDs = [id1, id2]..sort(); // trie les IDs alphabétiquement
    return '${sortedIDs[0]}_${sortedIDs[1]}';
  }

  Future<void> sendMessage(
    String receiverID,
    String message,
    String fcmToken,
  ) async {
    if (message.trim().isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final senderID = currentUser.uid;
    final chatRoomID = getChatRoomID(senderID, receiverID);
    final timestamp = Timestamp.now();

    final messageData = {
      'senderID': senderID,
      'receiverID': receiverID,
      'message': message.trim(),
      'timestamp': timestamp,
    };

    final chatRoomRef = FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomID);

    // 1. Crée la room si elle n'existe pas
    final chatRoomDoc = await chatRoomRef.get();
    if (!chatRoomDoc.exists) {
      await chatRoomRef.set({
        'users': [senderID, receiverID],
        'createdAt': timestamp,
        'lastMessage': message,
        'lastMessageTime': timestamp,
      });

      NotificationServices().sendPushNotification(
        deviceToken: fcmToken,
        title: "Nouveau Message 👋",
        body: message,
      );

      final notification = NotificationModel(
        senderRef: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid),
        receiverRef: FirebaseFirestore.instance
            .collection('users')
            .doc(receiverID),
        title: 'Nouveau Message 👋',
        message: message,
        type: "Chat",
        isRead: false,
        createdAt: Timestamp.now(),
      );
      await FirebaseFirestore.instance
          .collection('notifications')
          .add(notification.toJson());
    } else {
      // 2. Met à jour la room avec le dernier message
      await chatRoomRef.update({
        'lastMessage': message,
        'lastMessageTime': timestamp,
      });

      NotificationServices().sendPushNotification(
        deviceToken: fcmToken,
        title: "Nouveau Message 👋",
        body: message,
      );

      final notification = NotificationModel(
        senderRef: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid),
        receiverRef: FirebaseFirestore.instance
            .collection('users')
            .doc(receiverID),
        title: 'Nouveau Message 👋',
        message: message,
        type: "Chat",
        isRead: false,
        createdAt: Timestamp.now(),
      );
      await FirebaseFirestore.instance
          .collection('notifications')
          .add(notification.toJson());
    }

    // 3. Ajoute le message dans la sous-collection
    await chatRoomRef.collection('messages').add(messageData);
  }

  // get messages

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatRooms() {
    return _firestore
        .collection('chat_rooms')
        .where('users', arrayContains: _user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> createChatRoomIfNotExists(String receiverID) async {
    List<String> ids = [_user.uid, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    DocumentReference chatRoomRef = _firestore
        .collection('chat_rooms')
        .doc(chatRoomID);

    DocumentSnapshot chatRoomSnapshot = await chatRoomRef.get();

    if (!chatRoomSnapshot.exists) {
      await chatRoomRef.set({
        'users': ids,
        'lastMessage': '',
        'createdAt': Timestamp.now(),
      });
    }
  }
}
