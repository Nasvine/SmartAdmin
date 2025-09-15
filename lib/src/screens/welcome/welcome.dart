import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'onboarding_screen.dart';
/* import '../login/login.dart';
import '../register/register.dart'; */

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: InkWell(
        child: Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextCustom(
                  TheText: 'SMARTSERVICES',
                  TheTextSize: 30,
                  TheTextColor: ColorApp.tsecondaryColor,
                  TheTextFontWeight: FontWeight.bold,
                  TheTextFontFamily: "Poppins",
                ),
              ],
            ),
          ),
        ),
        onTap: () => Get.to(() => OnboardingScreen()),
      ),
    );
  }
}
