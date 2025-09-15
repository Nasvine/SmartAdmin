import 'dart:math';

import 'package:smart_admin/src/models/auth/role_enum.dart';
import 'package:smart_admin/src/repository/user_repository.dart';
import 'package:smart_admin/src/screens/auth/verify_email_screen.dart';
import 'package:smart_admin/src/constants/images.dart';
import 'package:smart_admin/src/controllers/auth/UserController.dart';
import 'package:smart_admin/src/repository/authentification_repository.dart';
import 'package:smart_admin/src/utils/loaders/loaders.dart';
import 'package:smart_admin/src/utils/popups/full_screen_loader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();

  // TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();
  final hidePassword = true.obs;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();
  GlobalKey<FormState> registerformKey = GlobalKey<FormState>();
  final _firebaseMessaging = FirebaseMessaging.instance;
  final RxString _fcmToken = "".obs;
  var acceptPolicy = false.obs;
  final RxDouble userLatitude = 0.0.obs;
  final RxDouble userLontitude = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    getFcmToken();
    _getCurrentLocation();
  }

  Future<String> getFcmToken() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    _fcmToken.value = fcmToken!;
    print('FCM Token: $fcmToken');
    return fcmToken!;
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    locationData = await location.getLocation();
    userLatitude.value = locationData.latitude!;
    userLontitude.value = locationData.longitude!;

    if (locationData.latitude == null || locationData.longitude == null) return;
  }

  Future<void> signup() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog("", ImageApp.tDocerAnimation);

      // Check Internet Connectivity
      // final isConnected = await NetworkManager.instance.isConnected();
      // if(!isConnected) return;

      // Form Validation
      if (!registerformKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await _getCurrentLocation();

      if (!acceptPolicy.value) {
        Get.snackbar(
          'Attention',
          'Veuillez accepter la politique de confidentialité pour continuer.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        TFullScreenLoader.stopLoading();
        return;
      }

      // Register User in the Firebase Authentication & Save user data
      final userCredential = await AuthentificationRepository.instance
          .registerWithEmailAndPassword(
            email.text.trim(),
            password.text.trim(),
          );

      // Save authentication
      final newUser = {
        'uid': userCredential.user!.uid,
        'fullName': fullName.text.trim(),
        'email': email.text.trim(),
        'phoneNumber': phoneNo.text.trim(),
        'userRole': RoleEnum.Role_1,
        'profilePicture': userCredential.user!.photoURL ?? "",
        'fcmToken': _fcmToken.value,
        'geopoint': GeoPoint(userLatitude.value, userLontitude.value),
      };

      final userRepository = Get.put(UserRepository());
      userRepository.saveUserRecord(newUser);

      // Move to verify Email Screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));

      // Show success Message
      TLoaders.successSnackBar(
        title: 'Congratulations',
        message: "tSuccessCreateCompte".tr,
      );

      // Redirect
      AuthentificationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "oH Snap", message: e.toString());
    }
  }

  Future<void> signUpWithPhone() async {
    print('icici');
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
        "We are processing your information...",
        ImageApp.tDocerAnimation,
      );

      // Check Internet Connectivity
      // final isConnected = await NetworkManager.instance.isConnected();
      // if(!isConnected) return;

      // Form Validation
      if (!registerformKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthentificationRepository.instance.phoneAuthentication(
        "+" + phoneNo.text.trim(),
      );

      // Move to verify Email Screen
      // Get.to(() => OtpVerifyScreen());

      // Show success Message
      TLoaders.successSnackBar(
        title: 'Congratulations',
        message: "Your account has been created! Verify sms to continue.",
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: "oH Snap", message: e.toString());
    }
  }
}
