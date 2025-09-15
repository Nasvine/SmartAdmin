import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'circle_icon_custom.dart';
import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';

class HeaderCloseCustom extends StatelessWidget {
  const HeaderCloseCustom({
    super.key,
    required this.isDark,
    required this.headerText,
    required this.headerIcon1,
    this.headerIcon2,
  });

  final bool isDark;
  final IconData? headerIcon1;
  final IconData? headerIcon2;
  final String headerText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleIconCustom(
          isDark: isDark,
          headerIcon1: headerIcon1,
          onPressed: () => Get.back(),
        ),
        TextCustom(
          TheText: headerText,
          TheTextSize: 20,
          TheTextFontWeight: FontWeight.bold,
          TheTextColor: ColorApp.tWhiteColor,
          TheTextFontFamily: "Poppins",
        ),
        headerIcon2 == null
            ? SizedBox()
            : CircleIconCustom(
                isDark: isDark,
                headerIcon1: headerIcon2,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
      ],
    );
  }
}
