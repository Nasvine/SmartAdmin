


import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../constants/colors.dart';
/* import '../../features/authentification/screens/verify/verify_email.dart'; */
import '../loaders/animation_loader_widget.dart';

class TFullScreenLoader {


  static void openLoadingDialog(String text, String animation){
    showDialog(
        context: Get.overlayContext!,
        barrierDismissible: true,
        builder: (_) => PopScope(
          canPop: false,
            child: Container(
              color: ColorApp.tWhiteColor,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 250,),
                  TAnimationLoaderWidget(text: text, animation: animation),
                ],
              ),
            )
        )
    );
  }

  static stopLoading(){
    Navigator.of(Get.overlayContext!).pop();
  }

}