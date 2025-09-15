import 'package:flutter/material.dart';
import 'package:smart_admin/src/constants/colors.dart';

class HeaderBackCustom extends StatelessWidget {
  const HeaderBackCustom({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 40,
          width: 40,
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
              Icons.close,
              color: isDark ? ColorApp.tWhiteColor : ColorApp.tBlackColor,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
