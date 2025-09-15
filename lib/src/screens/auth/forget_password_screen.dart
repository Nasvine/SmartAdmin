import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/constants/sizes.dart';
import 'package:smart_admin/src/constants/texts.dart';
import 'package:smart_admin/src/controllers/auth/ForgetPasswordController.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/texts/button_custom.dart';
import 'package:smart_admin/src/utils/texts/text_form_field_simple_custom.dart';
import 'package:smart_admin/src/utils/validators/validator.dart';
import 'package:smart_admin/src/utils/widget_theme/header_close_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_custom/text_custom.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final controllerForm = Get.put(ForgetPasswordController());
  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                HeaderCloseCustom(
                  isDark: isDark,
                  headerIcon1: Icons.arrow_back_sharp,
                  headerText: "",
                ),
                const SizedBox(height: 20),
                TextCustom(
                  TheText: TextApp.tForgetPassword,
                  TheTextSize: THelperFunctions.w(context, 0.04),
                  TheTextFontWeight: FontWeight.bold,
                  TheTextColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                ),

                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextCustom(
                      TheText: "tForgetLongText".tr,
                      TheTextSize: THelperFunctions.w(context, 0.03),
                      TheTextFontWeight: FontWeight.normal,
                      TheTextColor: THelperFunctions.isDarkMode(context)
                          ? ColorApp.tWhiteColor
                          : ColorApp.tBlackColor,
                      TheTextMaxLines: 4,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                  key: controllerForm.forgetPasswordFormKeyLogin,
                  child: Column(
                    children: [
                      TextFormFieldSimpleCustom(
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        borderRadiusBorder: 10,
                        cursorColor: THelperFunctions.isDarkMode(context)
                            ? ColorApp.tWhiteColor
                            : ColorApp.tBlackColor,
                        borderSideRadiusBorder:
                            THelperFunctions.isDarkMode(context)
                            ? ColorApp.tsecondaryColor
                            : ColorApp.tSombreColor,
                        borderRadiusFocusedBorder: 10,
                        borderSideRadiusFocusedBorder:
                            THelperFunctions.isDarkMode(context)
                            ? ColorApp.tsecondaryColor
                            : ColorApp.tSombreColor,
                        controller: controllerForm.email,
                        labelText: TextApp.tEmail,
                        labelStyleColor: THelperFunctions.isDarkMode(context)
                            ? ColorApp.tWhiteColor
                            : ColorApp.tBlackColor,
                        hintText: TextApp.tEmail,
                        hintStyleColor: THelperFunctions.isDarkMode(context)
                            ? ColorApp.tWhiteColor
                            : ColorApp.tBlackColor,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: THelperFunctions.isDarkMode(context)
                              ? ColorApp.tWhiteColor
                              : ColorApp.tBlackColor,
                        ),
                        validator: (value) => TValidator.validateEmail(value),
                      ),

                      const SizedBox(height: tFormHeight),
                      ButtonCustom(
                        text: TextApp.tSend,
                        textSize: 15,
                        buttonBackgroundColor: ColorApp.tsecondaryColor,
                        onPressed: () =>
                            controllerForm.sendPasswordResetEmail(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
