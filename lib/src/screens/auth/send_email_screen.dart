import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* class SendEmailScreen extends StatefulWidget {
  const SendEmailScreen({super.key});

  @override
  State<SendEmailScreen> createState() => _SendEmailScreenState();
}

class _SendEmailScreenState extends State<SendEmailScreen> {
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
                  headerText: "Send Email",
                ),
                const SizedBox(height: 20),
                const TextCustom(
                  TheText: TextApp.tLogin,
                  TheTextSize: 20,
                  TheTextFontWeight: FontWeight.bold,
                  TheTextColor: ColorApp.tWhiteColor,
                ),
                const SizedBox(height: 20),
                Form(
                  key: controllerForm.formKeyLogin,
                  child: Column(
                    children: [
                      TextFormFieldSimpleCustom(
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        borderRadiusBorder: 10,
                        cursorColor:
                            THelperFunctions.isDarkMode(context)
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
                        controller: controllerForm.subject,
                        labelText: "Subject",
                        labelStyleColor:
                            THelperFunctions.isDarkMode(context)
                                ? ColorApp.tWhiteColor
                                : ColorApp.tBlackColor,
                        hintText: "Subject",
                        hintStyleColor:
                            THelperFunctions.isDarkMode(context)
                                ? ColorApp.tWhiteColor
                                : ColorApp.tBlackColor,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color:
                              THelperFunctions.isDarkMode(context)
                                  ? ColorApp.tWhiteColor
                                  : ColorApp.tBlackColor,
                        ),
                        validator: (value) => TValidator.validationEmptyText('Subject',value),
                      ),

                      const SizedBox(height: tFormHeight),
                      TextFormFieldSimpleCustom(
                      
                          keyboardType: TextInputType.text,
                          controller: controllerForm.body,
                          obscureText: false,
                          borderRadiusBorder: 10,
                          cursorColor:
                              THelperFunctions.isDarkMode(context)
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
                          labelText: "Message",
                          labelStyleColor:
                              THelperFunctions.isDarkMode(context)
                                  ? ColorApp.tWhiteColor
                                  : ColorApp.tBlackColor,
                          hintText: "Message",
                          hintStyleColor:
                              THelperFunctions.isDarkMode(context)
                                  ? ColorApp.tWhiteColor
                                  : ColorApp.tBlackColor,
                          
                          validator: (value) => TValidator.validationEmptyText('Message',value),
                          MaxLines: 4,
                        ),
                      
                      const SizedBox(height: tFormHeight - 10),
                      ButtonCustom(
                        text: TextApp.tLogin,
                        textSize: 15,
                        buttonBackgroundColor: ColorApp.tsecondaryColor,
                        onPressed: () => controllerForm.sendEmail(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: tFormHeight - 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('OR', textAlign: TextAlign.center),
                    SizedBox(height: tFormHeight - 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {} /* => controller.googleSignIn() */,
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
                              fontSize: 14,
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
 */