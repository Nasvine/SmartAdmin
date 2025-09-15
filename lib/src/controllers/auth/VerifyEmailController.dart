import 'dart:async';

import 'package:smart_admin/src/constants/texts.dart';
import 'package:smart_admin/src/screens/auth/login_screen.dart';
import 'package:smart_admin/src/screens/welcome/success_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smart_admin/src/models/auth/role_enum.dart';
import 'package:smart_admin/src/repository/user_repository.dart';
import 'package:smart_admin/src/screens/auth/verify_email_screen.dart';
import 'package:smart_admin/src/constants/images.dart';
import 'package:smart_admin/src/controllers/auth/UserController.dart';
import 'package:smart_admin/src/repository/authentification_repository.dart';
import 'package:smart_admin/src/utils/loaders/loaders.dart';
import 'package:smart_admin/src/utils/popups/full_screen_loader.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final _auth = FirebaseAuth.instance;

  /// Send Email Verification Link
  sendEmailVerification() async {
    TFullScreenLoader.openLoadingDialog("", ImageApp.tDocerAnimation);

    // Form Validation
    if (!formKey.currentState!.validate()) {
      TFullScreenLoader.stopLoading();
      return;
    }

    try {
      // print(_auth.currentUser!.email);
      print(email.text);

      if (_auth.currentUser!.email == email.text) {
        final user = _auth.currentUser!;
        await user.sendEmailVerification();
      }

      TLoaders.successSnackBar(
        title: "tEmailSent".tr,
        message: "tEmailSentMessage".tr,
      );
      TFullScreenLoader.stopLoading();
      Get.to(LoginScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "oH Snap", message: e.toString());
    }
  }

  /// Timer to automatically redirect on Email Verification
  setTimerForAutoRedirect() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(
          () => SuccessScreen(
            image: ImageApp.tSuccessRegister,
            title: TextApp.tAccountCreatedTitle,
            subTitle: TextApp.tAccountCreatedSubTitle,
            onPressed: () =>
                AuthentificationRepository.instance.screenRedirect(),
          ),
        );
      }
    });
  }

  /// Manually Check if Email Verified
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser!.emailVerified);

    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
        () => SuccessScreen(
          image: ImageApp.tSuccessRegister,
          title: TextApp.tAccountCreatedTitle,
          subTitle: TextApp.tAccountCreatedSubTitle,
          onPressed: () => AuthentificationRepository.instance.screenRedirect(),
        ),
      );
    }
  }
}
