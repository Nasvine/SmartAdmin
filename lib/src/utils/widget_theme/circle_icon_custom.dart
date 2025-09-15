import 'package:flutter/material.dart';
import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';

class CircleIconCustom extends StatelessWidget {
  const CircleIconCustom({
    super.key,
    required this.isDark,
    required this.headerIcon1,
    this.onPressed,
  });

  final bool isDark;
  final IconData? headerIcon1;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: THelperFunctions.h(context, 0.05),
      width: THelperFunctions.h(context, 0.05),
      decoration: BoxDecoration(
        color: isDark ? ColorApp.tBlackColor : ColorApp.tWhiteColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isDark ? ColorApp.tWhiteColor : ColorApp.tSombreColor,
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(
          headerIcon1,
          color: isDark ? ColorApp.tWhiteColor : ColorApp.tBlackColor,
          size: THelperFunctions.h(context, 0.03),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
