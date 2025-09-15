

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';

class TLoaders{

  static successSnackBar({required title, message= "", duration = 5}){
    Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: ColorApp.tWhiteColor,
        backgroundColor: ColorApp.tsecondaryColor,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: EdgeInsets.all(20),
        icon: Icon(Icons.check, color: ColorApp.tWhiteColor,)
    );
  }

  static warningSnackBar({required title, message= ""}){
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: ColorApp.tWhiteColor,
      backgroundColor: ColorApp.tsecondaryColor,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(20),
      icon: Icon(Icons.warning_amber, color: ColorApp.tWhiteColor,)
    );
  }

  static errorSnackBar({required title, message= ""}){
    Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: ColorApp.tWhiteColor,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5),
        margin: EdgeInsets.all(20),
        icon: Icon(Icons.warning_amber, color: ColorApp.tWhiteColor,
        )
    );
  }
}