import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:select_field/select_field.dart';

class SelectFormFieldSimpleCustom extends StatelessWidget {
  const SelectFormFieldSimpleCustom({
    required this.borderRadiusBorder,
    required this.borderSideRadiusBorder,
    required this.borderRadiusFocusedBorder,
    required this.borderSideRadiusFocusedBorder,
    required this.cursorColor,
    required this.hintStyleColor,
    required this.labelStyleColor,
    required this.Options,
    required this.optionsMaps,
    this.textController,
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
  final List<String> Options;
  final List<Option<String>> optionsMaps;
  final TextEditingController? textController;

  @override
  Widget build(BuildContext context) {
    return SelectField<String>(
      options: optionsMaps,
      initialOption: Option<String>(label: Options[0], value: Options[0]),
      //searchOptions: ,
      textController: textController,
      menuPosition: MenuPosition.below,
      onTextChanged: (value) => debugPrint(value),
      onOptionSelected: (option) => debugPrint(option.toString()),
      inputStyle: const TextStyle(),
      menuDecoration: MenuDecoration(
        margin: const EdgeInsets.only(top: 8),
        height: 365,
        alignment: MenuAlignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: const Offset(1, 1),
              color: Colors.brown[300]!,
              blurRadius: 3,
            ),
          ],
        ),
        animationDuration: const Duration(milliseconds: 400),
        buttonStyle: TextButton.styleFrom(
          fixedSize: const Size(double.infinity, 60),
          backgroundColor: Colors.green[100],
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(16),
          shape: const RoundedRectangleBorder(),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: THelperFunctions.isDarkMode(context)
                ? ColorApp.tsecondaryColor
                : ColorApp.tSombreColor,
          ),
        ),
        separatorBuilder: (context, index) => Container(
          height: 1,
          width: double.infinity,
          color: THelperFunctions.isDarkMode(context)
              ? ColorApp.tsecondaryColor
              : ColorApp.tSombreColor,
        ),
      ),
      inputDecoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        labelStyle: TextStyle(color: labelStyleColor, fontSize: 14),
        hintText: hintText,
        hintStyle: TextStyle(color: hintStyleColor, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusBorder)),
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
    );
  }
}
