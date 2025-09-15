import 'package:flutter/material.dart';

class TextFormFieldSimpleCustom extends StatelessWidget {
  const TextFormFieldSimpleCustom({
    required this.keyboardType,
    required this.borderRadiusBorder,
    required this.borderSideRadiusBorder,
    required this.borderRadiusFocusedBorder,
    required this.borderSideRadiusFocusedBorder,
    required this.cursorColor,
    required this.controller,
    required this.hintStyleColor,
    required this.labelStyleColor,
    required this.obscureText,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.MaxLines = 1,
    super.key,
  });

  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final double borderRadiusBorder;
  final Color borderSideRadiusBorder;
  final Color cursorColor;
  final Color labelStyleColor;
  final Color hintStyleColor;
  final double borderRadiusFocusedBorder;
  final Color borderSideRadiusFocusedBorder;
  final bool obscureText;
  final int? MaxLines;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          cursorColor: cursorColor,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            labelText: labelText,
            labelStyle: TextStyle(color: labelStyleColor, fontSize: 14),
            hintText: hintText,
            hintStyle: TextStyle(color: hintStyleColor, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadiusBorder),
              ),
              borderSide: BorderSide(color: borderSideRadiusBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadiusFocusedBorder),
              ),
              borderSide: BorderSide(
                color: borderSideRadiusFocusedBorder,
                width: 1,
              ),
            ),
          ),
          maxLines: MaxLines,
          onChanged: (value) {
            setState(() {}); // Permet de redessiner le bouton clear
            if (onChanged != null) {
              onChanged!(value);
            }
          },
        );
      },
    );
  }
}
