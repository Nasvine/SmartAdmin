
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    this.titleColor,
    this.icon,
    this.iconColor,
    this.onTap,
  });

  final String title;
  final Color? titleColor;
  final IconData? icon;
  final Color? iconColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: titleColor)),
      onTap: onTap,
    );
  }
}