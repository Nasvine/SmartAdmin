import 'package:smart_admin/src/controllers/auth/RegisterController.dart';
import 'package:smart_admin/src/screens/auth/login_screen.dart';
import 'package:smart_admin/src/screens/settings/policy_home_page.dart';
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
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final controllerForm = Get.put(RegisterController());
  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
       resizeToAvoidBottomInset: true,
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
                  headerIcon1: Icons.close,
                  headerText: "",
                ),
                const SizedBox(height: 10),
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

                const SizedBox(height: 10),
                TextCustom(
                  TheText: "tWelcomeLogin".tr,
                  TheTextSize: 20,
                  TheTextFontWeight: FontWeight.bold,
                  TheTextColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                ),
                const SizedBox(height: 10),
                TextCustom(
                  TheText: "tRegisterTitle".tr,
                  TheTextSize: 15,
                  TheTextFontWeight: FontWeight.normal,
                  TheTextColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                ),
                const SizedBox(height: 10),
                TextCustom(
                  TheText: "tRegisterSubTitle".tr,
                  TheTextSize: 15,
                  TheTextFontWeight: FontWeight.normal,
                  TheTextColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                ),
                const SizedBox(height: 10),
                Form(
                  key: controllerForm.registerformKey,
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
                        controller: controllerForm.fullName,
                        labelText: TextApp.tFullName,
                        labelStyleColor: THelperFunctions.isDarkMode(context)
                            ? ColorApp.tWhiteColor
                            : ColorApp.tBlackColor,
                        hintText: TextApp.tFullName,
                        hintStyleColor: THelperFunctions.isDarkMode(context)
                            ? ColorApp.tWhiteColor
                            : ColorApp.tBlackColor,
                        prefixIcon: Icon(
                          Icons.person_2_outlined,
                          color: THelperFunctions.isDarkMode(context)
                              ? ColorApp.tWhiteColor
                              : ColorApp.tBlackColor,
                        ),
                        validator: (value) => TValidator.validationEmptyText(
                          "Nom & Prénoms",
                          value,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormFieldSimpleCustom(
                        keyboardType: TextInputType.number,
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
                        controller: controllerForm.phoneNo,
                        labelText: TextApp.tPhoneNo,
                        labelStyleColor: THelperFunctions.isDarkMode(context)
                            ? ColorApp.tWhiteColor
                            : ColorApp.tBlackColor,
                        hintText: TextApp.tPhoneNo,
                        hintStyleColor: THelperFunctions.isDarkMode(context)
                            ? ColorApp.tWhiteColor
                            : ColorApp.tBlackColor,
                        prefixIcon: Icon(
                          Icons.phone_android_outlined,
                          color: THelperFunctions.isDarkMode(context)
                              ? ColorApp.tWhiteColor
                              : ColorApp.tBlackColor,
                        ),
                        validator: (value) =>
                            TValidator.validationPhoneNumber(value),
                      ),
                      const SizedBox(height: 10),
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

                      const SizedBox(height: 10),
                      Obx(
                        () => TextFormFieldSimpleCustom(
                          keyboardType: TextInputType.text,
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
                          controller: controllerForm.password,
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
                      const SizedBox(height: tFormHeight - 20),
                      Obx(
                        () => CheckboxListTile(
                          value: controllerForm.acceptPolicy.value,
                          onChanged: (value) {
                            controllerForm.acceptPolicy.value = value!;
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          title: GestureDetector(
                            onTap: () {
                              // Naviguer vers la page Politique de confidentialité
                              Get.to(() => const PrivacyPolicyOwnerHomePage());
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "J'accepte la ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Politique de confidentialité",
                                    style: TextStyle(
                                      color: ColorApp.tsecondaryColor,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: tFormHeight - 20),
                ButtonCustom(
                  text: TextApp.tRegister.toUpperCase(),
                  textSize: 15,
                  buttonBackgroundColor: ColorApp.tsecondaryColor,
                  onPressed: () => controllerForm.signup(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() => LoginScreen()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            TextApp.tAlreadyHave,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(width: 5),
                          TextButton(
                            onPressed: () => Get.to(() => LoginScreen()),
                            child: Text(
                              TextApp.tLogin,
                              style: TextStyle(
                                color: ColorApp.tsecondaryColor,
                                fontSize: THelperFunctions.w(context, 0.03),
                                fontWeight: FontWeight.bold,
                              ),
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
