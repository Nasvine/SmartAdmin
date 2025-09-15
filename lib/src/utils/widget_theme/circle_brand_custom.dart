import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';
import 'package:flutter/material.dart';

class CircleBrandCustom extends StatelessWidget {
  const CircleBrandCustom({
    required this.imagePath,
    required this.brandName,
    this.brandNameSize = 12.0,
    this.containerColor = ColorApp.tsecondaryPercent5Color,
    super.key,
  });

  final String imagePath;
  final String brandName;
  final double brandNameSize;
  final Color containerColor;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Ajustements responsives basés sur la largeur de l’écran
    final containerSize = screenWidth * 0.20; // Par exemple, 12% de la largeur
    final imageSize = containerSize * 0.6; // 60% de la taille du container
    final textSize = screenWidth < 350
        ? brandNameSize * 0.8
        : screenWidth < 600
        ? brandNameSize
        : brandNameSize * 1.2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(100),
          ),
          width: containerSize,
          height: containerSize,
          child: Center(
            child: Image.network(
              imagePath,
              height: imageSize,
              width: imageSize,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 5),
        TextCustom(
          TheText: brandName,
          TheTextSize: textSize,
          TheTextFontWeight: FontWeight.normal,
          TheTextColor: THelperFunctions.isDarkMode(context)
              ? ColorApp.tWhiteColor
              : ColorApp.tBlackColor,
        ),
      ],
    );
  }
}
