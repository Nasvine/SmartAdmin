import 'package:smart_admin/src/constants/colors.dart';
import 'package:flutter/material.dart';

class DrawerHeaderCustom extends StatelessWidget {
  const DrawerHeaderCustom({
    super.key,
    required this.displayName,
    required this.email,
    required this.photo,
  });

  final String displayName;
  final String email;
  final String? photo;

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: Text(
        displayName,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      accountEmail: Text(email),
      otherAccountsPictures: [
        Icon(Icons.brightness_3, color: ColorApp.tWhiteColor),
      ],
      currentAccountPicture: CircleAvatar(
        // backgroundImage: AssetImage(photo),
        backgroundImage: photo == null
            ? AssetImage("images/cover.jpg")
            : NetworkImage(photo!),
      ),
    );
  }
}
