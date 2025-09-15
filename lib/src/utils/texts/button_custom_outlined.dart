import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/constants/sizes.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';
import 'package:flutter/material.dart';

class ButtonCustomOutlined extends StatelessWidget {
  const ButtonCustomOutlined({
    this.buttonBackgroundColor,
    required this.onPressed,
    required this.text,
    required this.textSize,
    this.buttonWith = double.infinity,
    this.buttonRaduis = 5,
    this.buttonPaddingVertical = tButtonHeight,
    super.key,
  });

  final Color? buttonBackgroundColor;
  final void Function()? onPressed;
  final String text;
  final double textSize;
  final double buttonWith;
  final double buttonRaduis;
  final double buttonPaddingVertical;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWith,
      child: OutlinedButton(
        onPressed: onPressed,
        child: TextCustom(
          TheText: text,
          TheTextSize: textSize,
          TheTextFontWeight: FontWeight.bold,
          TheTextColor: ColorApp.tPrimaryColor,
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: tButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRaduis),
          ),
          foregroundColor: ColorApp.tWhiteColor,
          backgroundColor: THelperFunctions.isDarkMode(context)
              ? ColorApp.tBlackColor
              : ColorApp.tWhiteColor,
          side: BorderSide(color: ColorApp.tPrimaryColor),
        ),
      ),
    );
  }
}
