import 'package:smart_admin/src/exeptions/firebase_auth_exception.dart';
import 'package:smart_admin/src/exeptions/format_exception.dart';
import 'package:smart_admin/src/models/auth/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'authentification_repository.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Functions to save user data to Firestore
  Future<void> saveUserRecord(Map<String, dynamic> user) async {
    try {
      await _db.collection("users").doc(user['uid']).set(user);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
      // final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      // print('FIREBASE AUTH EXCEPTION - ${ex.message}');
    } on FormatException catch (_) {
      throw TFormatException();
    } catch (e) {
      // final ex = SignUpWithEmailAndPasswordFailure();
      // print('EXCEPTION - ${ex.message}');
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Functions to fetch user details based on user ID
  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("users")
          .doc(AuthentificationRepository.instance.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
      // final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      // print('FIREBASE AUTH EXCEPTION - ${ex.message}');
    } on FormatException catch (_) {
      throw TFormatException();
    } catch (e) {
      // final ex = SignUpWithEmailAndPasswordFailure();
      // print('EXCEPTION - ${ex.message}');
      throw 'Something went wrong. Please try again.';
    }
  }

  Stream<UserModel> fetchUserDetailsRealTime() {
    return _db
        .collection("users")
        .doc(AuthentificationRepository.instance.authUser?.uid)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            return UserModel.fromSnapshot(snapshot);
          } else {
            return UserModel.empty();
          }
        });
  }

  /// Functions to update user data in Firestore
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db
          .collection("users")
          .doc(updatedUser.uid)
          .update(updatedUser.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Update any field in specific users Collections
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("users")
          .doc(AuthentificationRepository.instance.authUser?.uid)
          .update(json);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Function to Remove user Data from Firestore
  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("users").doc(userId).delete();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}
