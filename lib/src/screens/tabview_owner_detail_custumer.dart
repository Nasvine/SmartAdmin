import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/controllers/auth/UserController.dart';
import 'package:smart_admin/src/models/auth/user_model.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/widget_theme/circle_icon_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_custom/text_custom.dart';

class TabviewOwnerDetailCustumer extends StatelessWidget {
  const TabviewOwnerDetailCustumer({
    super.key,
    required this.isDark,
    required this.ref,
  });

  final bool isDark;
  final DocumentReference ref;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return FutureBuilder<UserModel?>(
      future: controller.getUserByRef(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const Icon(Icons.broken_image, size: 30);
        }

        final user = snapshot.data!;
        print(user.fullName);
        return Row(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(user.profilePicture!),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      TheText: user.fullName,
                      TheTextSize: THelperFunctions.w(context, 0.04),
                      TheTextFontWeight: FontWeight.bold,
                      TheTextColor: THelperFunctions.isDarkMode(context)
                          ? ColorApp.tWhiteColor
                          : ColorApp.tBlackColor,
                    ),
                    Text(user.email, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  IconButton(
                    icon: CircleIconCustom(
                      isDark: isDark,
                      headerIcon1: Icons.messenger_outline_rounded,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: CircleIconCustom(
                      isDark: isDark,
                      headerIcon1: Icons.call,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
