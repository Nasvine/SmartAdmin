import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/constants/sizes.dart';
import 'package:smart_admin/src/constants/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.onPressed,
  });

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              /// Image
              Lottie.asset(
                image,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              const SizedBox(height: tFormHeight - 10),

              /// Title & SubTitle
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: ColorApp.tsecondaryColor,
                ),
              ),
              const SizedBox(height: tFormHeight - 20),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: ColorApp.tsecondaryColor,
                ),
              ),
              const SizedBox(height: tFormHeight - 20),

              /// Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(TextApp.tContinue.toUpperCase()),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    foregroundColor: ColorApp.tWhiteColor,
                    backgroundColor: ColorApp.tsecondaryColor,
                    side: BorderSide(color: ColorApp.tsecondaryColor),
                    padding: EdgeInsets.symmetric(vertical: tButtonHeight),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
