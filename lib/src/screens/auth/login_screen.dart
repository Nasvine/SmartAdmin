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

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerForm = Get.put(LoginController());
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),

                /*  HeaderCloseCustom(
                  isDark: isDark,
                  headerIcon1: Icons.arrow_back_sharp,
                  headerText: "",
                ),
                const SizedBox(height: 20), */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Image.network(
                        "https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/smart-service-49ew28/assets/uoxtvrh4smpk/Logo_smart.png",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                TextCustom(
                  TheText: "tWelcomeLogin".tr,
                  TheTextSize: THelperFunctions.w(context, 0.05),
                  TheTextFontWeight: FontWeight.bold,
                  TheTextColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                ),
                const SizedBox(height: tFormHeight - 20),
                TextCustom(
                  TheText: "tWelcomeLogin1".tr,
                  TheTextSize: THelperFunctions.w(context, 0.04),
                  TheTextFontWeight: FontWeight.normal,
                  TheTextColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                ),
                const SizedBox(height: tFormHeight - 20),
                TextCustom(
                  TheText: "tWelcomeLogin2".tr,
                  TheTextSize: THelperFunctions.w(context, 0.04),
                  TheTextFontWeight: FontWeight.normal,
                  TheTextColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                ),
                const SizedBox(height: tFormHeight - 20),
                Form(
                  key: controllerForm.formKeyLogin,
                  child: Column(
                    children: [
                      TextFormFieldSimpleCustom(
                        keyboardType: TextInputType.text,
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

                      const SizedBox(height: tFormHeight - 10),
                      Obx(
                        () => TextFormFieldSimpleCustom(
                          keyboardType: TextInputType.text,
                          controller: controllerForm.password,
                          obscureText: controllerForm.hidePassword.value,
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
                          labelText: TextApp.tPassword,
                          labelStyleColor: THelperFunctions.isDarkMode(context)
                              ? ColorApp.tWhiteColor
                              : ColorApp.tBlackColor,
                          hintText: TextApp.tPassword,
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
                          validator: (value) =>
                              TValidator.validatePassword(value),
                        ),
                      ),
                      const SizedBox(height: tFormHeight - 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /*  Row(
                            children: [
                              /*  Checkbox(value: false, onChanged: (g) {}), */
                              TextCustom(
                                TheText: TextApp.tRemerberMe,
                                TheTextSize: THelperFunctions.w(context, 0.03),
                                TheTextColor:
                                    THelperFunctions.isDarkMode(context)
                                        ? ColorApp.tWhiteColor
                                        : ColorApp.tBlackColor,
                              ),
                            ],
                          ), */
                          TextButton(
                            onPressed: () =>
                                Get.to(() => ForgetPasswordScreen()),
                            child: TextCustom(
                              TheText: TextApp.tForgetPassword,
                              TheTextSize: THelperFunctions.w(context, 0.03),
                              TheTextColor: ColorApp.tsecondaryColor,
                              TheTextFontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: tFormHeight - 20),
                      ButtonCustom(
                        text: TextApp.tLogin,
                        textSize: 15,
                        buttonBackgroundColor: ColorApp.tsecondaryColor,
                        onPressed: () =>
                            controllerForm.emailAndPasswordSignIn(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: tFormHeight - 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('OR', textAlign: TextAlign.center),
                    SizedBox(height: tFormHeight - 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => controllerForm.googleSignIn(),
                        icon: Image.asset(
                          ImageApp.tGoogleLogoImage,
                          width: 20.0,
                        ),
                        label: Text(
                          TextApp.tSignWithGoogle,
                          style: TextStyle(color: ColorApp.tsecondaryColor),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          foregroundColor: ColorApp.tWhiteColor,
                          // side: BorderSide(color: ColorApp.tBlackColor)
                        ),
                      ),
                    ),
                    SizedBox(height: tFormHeight),

                    GestureDetector(
                      onTap: () => Get.to(() => RegisterScreen()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            TextApp.tAlreadyHaveAnAccount,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(width: tFormHeight - 20),
                          Text(
                            TextApp.tRegister,
                            style: TextStyle(
                              color: ColorApp.tsecondaryColor,
                              fontSize: THelperFunctions.w(context, 0.03),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
