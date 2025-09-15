


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvisController extends GetxController {
  final RxInt selectedStars = 0.obs;
  final TextEditingController commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference? existingAvisDoc;

  Future<void> loadUserAvis() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final query = await _firestore
        .collection('avisapk')
        .where('userRef', isEqualTo: _firestore.collection('users').doc(user.uid))
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      existingAvisDoc = doc.reference;
      selectedStars.value = doc['notes'];
      commentController.text = doc['comment'];
    }
  }

  Future<void> submitAvis() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final data = {
      'userRef': _firestore.collection('users').doc(user.uid),
      'notes': selectedStars.value,
      'comment': commentController.text.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    try {
      if (existingAvisDoc != null) {
        await existingAvisDoc!.update(data);
        Get.back();
        Get.snackbar("Avis modifié", "Merci d'avoir mis à jour votre avis !");
      } else {
        data['createdAt'] = FieldValue.serverTimestamp();
        await _firestore.collection('avisapk').add(data);
        Get.back();
        Get.snackbar("Merci 🙏", "Votre avis a été enregistré !");
      }
    } catch (e) {
      Get.snackbar("Erreur", "Impossible d'enregistrer/modifier l'avis : $e");
    }
  }
}

