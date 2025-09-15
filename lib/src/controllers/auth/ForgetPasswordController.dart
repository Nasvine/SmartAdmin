import 'package:smart_admin/src/constants/images.dart';
import 'package:smart_admin/src/repository/authentification_repository.dart';
import 'package:smart_admin/src/screens/auth/login_screen.dart';
import 'package:smart_admin/src/utils/loaders/loaders.dart';
import 'package:smart_admin/src/utils/popups/full_screen_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  void onInit() {
    super.onInit();
  }

  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKeyLogin = GlobalKey<FormState>();

  /// Send Reset Password Email
  sendPasswordResetEmail() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog("", ImageApp.tDocerAnimation);

      // Form validation
      if (!forgetPasswordFormKeyLogin.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthentificationRepository.instance.sendPasswordResetEmail(
        email.text.trim(),
      );

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show Success Screen
      TLoaders.successSnackBar(
        title: "tEmailSent".tr,
        message: "tEmailLink".tr,
      );

      // Redirect
      Get.to(() => LoginScreen());
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "oH Snap", message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
        "Logging you in ...",
        ImageApp.tDocerAnimation,
      );

      // Send Email to Reset Password
      await AuthentificationRepository.instance.sendPasswordResetEmail(email);

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show Success Screen
      TLoaders.successSnackBar(
        title: 'Email Sent',
        message: "Email link Sent to Reset your Password".tr,
      );
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();

      TLoaders.errorSnackBar(title: "oH Snap", message: e.toString());
    }
  }
}
