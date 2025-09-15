
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';


class DateFormFieldSimpleCustom extends StatelessWidget {
  const DateFormFieldSimpleCustom({
    required this.borderRadiusBorder,
    required this.borderSideRadiusBorder,
    required this.borderRadiusFocusedBorder,
    required this.borderSideRadiusFocusedBorder,
    required this.cursorColor,
    required this.hintStyleColor,
    required this.labelStyleColor,
    required this.onChanged,
    required this.mode,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    super.key,
  });

  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(DateTime?)? validator;
  final double borderRadiusBorder;
  final Color borderSideRadiusBorder;
  final Color cursorColor;
  final Color labelStyleColor;
  final Color hintStyleColor;
  final double borderRadiusFocusedBorder;
  final Color borderSideRadiusFocusedBorder;
  final Function(DateTime?)? onChanged;
  final DateTimeFieldPickerMode mode;

  @override
  Widget build(BuildContext context) {
  DateTimeFieldPickerPlatform platform = DateTimeFieldPickerPlatform.material;
    return DateTimeFormField(
       validator: validator,
       onChanged: onChanged,
       canClear: true,
       initialValue: DateTime.now(),
       pickerPlatform: platform,
       mode: mode,
       decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText:labelText,
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
          borderRadius:BorderRadius.all(Radius.circular(borderRadiusBorder)),
          borderSide: BorderSide(
            color: borderSideRadiusBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusFocusedBorder)),
          borderSide: BorderSide(
            color: borderSideRadiusFocusedBorder,
            width: 1,
          ),
        ),
        
      ),
    );
  }
}
