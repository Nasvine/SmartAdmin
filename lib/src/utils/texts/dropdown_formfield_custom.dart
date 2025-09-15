import 'package:flutter/material.dart';

class DropdownFormFieldCustom<T> extends StatelessWidget {
  const DropdownFormFieldCustom({
    required this.items,
    required this.onChanged,
    required this.value,
    required this.borderRadiusBorder,
    required this.borderSideRadiusBorder,
    required this.borderRadiusFocusedBorder,
    required this.borderSideRadiusFocusedBorder,
    required this.cursorColor,
    required this.hintStyleColor,
    required this.labelStyleColor,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    super.key,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final double borderRadiusBorder;
  final Color borderSideRadiusBorder;
  final double borderRadiusFocusedBorder;
  final Color borderSideRadiusFocusedBorder;
  final Color cursorColor;
  final Color labelStyleColor;
  final Color hintStyleColor;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      validator: validator,
      items: items,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        labelStyle: TextStyle(
          color: labelStyleColor,
          fontSize: 14,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintStyleColor,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusBorder),
          borderSide: BorderSide(
            color: borderSideRadiusBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusFocusedBorder),
          borderSide: BorderSide(
            color: borderSideRadiusFocusedBorder,
            width: 1,
          ),
        ),
      ),
      dropdownColor: Colors.white,
      style: TextStyle(color: cursorColor),
    );
  }
}
