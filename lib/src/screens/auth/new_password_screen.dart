import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smart_admin/src/constants/images.dart';
import 'package:smart_admin/src/controllers/auth/login_controller.dart';
import 'package:smart_admin/src/screens/auth/forget_password_screen.dart';
import 'package:smart_admin/src/screens/auth/register_sreen.dart';
import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/constants/sizes.dart';
import 'package:smart_admin/src/constants/texts.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/texts/button_custom.dart';
import 'package:smart_admin/src/utils/texts/text_form_field_simple_custom.dart';
import 'package:smart_admin/src/utils/validators/validator.dart';
import 'package:smart_admin/src/utils/widget_theme/header_close_custom.dart';
import 'package:text_custom/text_custom.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final controllerForm = Get.put(LoginController());
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
                const TextCustom(
                  TheText: TextApp.tNewPassword,
                  TheTextSize: 20,
                  TheTextFontWeight: FontWeight.bold,
                  TheTextColor: ColorApp.tWhiteColor,
                ),
                const SizedBox(height: 20),
                Obx(
                  () => TextFormFieldSimpleCustom(
                    keyboardType: TextInputType.text,
                    obscureText: controllerForm.hidePassword.value,
                    borderRadiusBorder: 10,
                    cursorColor: THelperFunctions.isDarkMode(context)
                        ? ColorApp.tWhiteColor
                        : ColorApp.tBlackColor,
                    borderSideRadiusBorder: THelperFunctions.isDarkMode(context)
                        ? ColorApp.tsecondaryColor
                        : ColorApp.tSombreColor,
                    borderRadiusFocusedBorder: 10,
                    borderSideRadiusFocusedBorder:
                        THelperFunctions.isDarkMode(context)
                        ? ColorApp.tsecondaryColor
                        : ColorApp.tSombreColor,
                    controller: TextEditingController(),
                    labelText: TextApp.tPasswordNew,
                    labelStyleColor: THelperFunctions.isDarkMode(context)
                        ? ColorApp.tWhiteColor
                        : ColorApp.tBlackColor,
                    hintText: TextApp.tPasswordNew,
                    hintStyleColor: THelperFunctions.isDarkMode(context)
                        ? ColorApp.tWhiteColor
                        : ColorApp.tBlackColor,
                    prefixIcon: Icon(
                      Icons.fingerprint,
                      color: THelperFunctions.isDarkMode(context)
                          ? ColorApp.tWhiteColor
                          : ColorApp.tBlackColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => controllerForm.hidePassword.value =
                          !controllerForm.hidePassword.value,
                      icon: Icon(
                        controllerForm.hidePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => TextFormFieldSimpleCustom(
                    keyboardType: TextInputType.text,
                    obscureText: controllerForm.hidePassword.value,
                    borderRadiusBorder: 10,
                    cursorColor: THelperFunctions.isDarkMode(context)
                        ? ColorApp.tWhiteColor
                        : ColorApp.tBlackColor,
                    borderSideRadiusBorder: THelperFunctions.isDarkMode(context)
                        ? ColorApp.tsecondaryColor
                        : ColorApp.tSombreColor,
                    borderRadiusFocusedBorder: 10,
                    borderSideRadiusFocusedBorder:
                        THelperFunctions.isDarkMode(context)
                        ? ColorApp.tsecondaryColor
                        : ColorApp.tSombreColor,
                    controller: TextEditingController(),
                    labelText: TextApp.tPasswordNewConfirm,
                    labelStyleColor: THelperFunctions.isDarkMode(context)
                        ? ColorApp.tWhiteColor
                        : ColorApp.tBlackColor,
                    hintText: TextApp.tPasswordNewConfirm,
                    hintStyleColor: THelperFunctions.isDarkMode(context)
                        ? ColorApp.tWhiteColor
                        : ColorApp.tBlackColor,
                    prefixIcon: Icon(
                      Icons.fingerprint,
                      color: THelperFunctions.isDarkMode(context)
                          ? ColorApp.tWhiteColor
                          : ColorApp.tBlackColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => controllerForm.hidePassword.value =
                          !controllerForm.hidePassword.value,
                      icon: Icon(
                        controllerForm.hidePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: tFormHeight),
                ButtonCustom(
                  text: TextApp.tSend,
                  textSize: 15,
                  buttonBackgroundColor: ColorApp.tsecondaryColor,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
