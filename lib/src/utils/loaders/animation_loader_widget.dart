

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class TAnimationLoaderWidget extends StatelessWidget{

  const TAnimationLoaderWidget({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
  });

  final String text;
  final String animation;

  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animation, width: MediaQuery.of(context).size.width * 0.8),
          const SizedBox(height: tFormHeight-10,),
          Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: ColorApp.tBlackColor),textAlign: TextAlign.center,),
          SizedBox(height: tFormHeight-20,),
          showAction ? SizedBox(
            width: 250,
            child: OutlinedButton(
              onPressed: onActionPressed,
              style: OutlinedButton.styleFrom(backgroundColor: ColorApp.tWhiteColor),
              child: Text(
                actionText!,
                style: TextStyle(color: ColorApp.tWhiteColor),
              ),

            ),
          ) : const SizedBox()
        ],
      ),
    );
  }
  
}