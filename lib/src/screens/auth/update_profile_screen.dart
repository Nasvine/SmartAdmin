import 'package:smart_admin/src/controllers/auth/UpdateProfileController.dart';
import 'package:smart_admin/src/controllers/auth/UserController.dart';
import 'package:smart_admin/src/models/auth/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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

class UpdateUserProfileScreen extends StatelessWidget {
  final controller = Get.put(UpdateProfileController());
  final usercontroller = Get.put(UserController());
  UpdateUserProfileScreen({super.key, required this.user}) {
    controller.first_name.text = user.fullName;
    controller.email.text = user.email;
    controller.phoneNumber.text = user.phoneNumber;
    controller.userAdress.text = user.userAdress;
    controller.imageUrl.value = user.profilePicture!;
  }
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          TextApp.tEditProfile,
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        actions: [
          // IconButton(onPressed: () =>(), icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(tDefaultSize),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => Positioned(
                  top: 40,
                  left: 90,
                  bottom: 30,
                  child: GestureDetector(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.black,
                          child: controller.imageUrl.value == ''
                              ? CircleAvatar(
                                  radius: 80,
                                  backgroundImage: AssetImage(ImageApp.tCover),
                                )
                              : ClipOval(
                                  child: Image.network(
                                    width: 150,
                                    height: 150,
                                    controller.imageUrl.value,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.error,
                                        size: 50,
                                        color: Colors.red,
                                      );
                                    },
                                  ),
                                ),
                        ),
                        // Loader pendant l’upload
                        if (controller.isUploading.value)
                          const Positioned.fill(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
                    onTap: () {
                      controller.showImagePickerOption(context);
                    },
                  ),
                ),
              ),
              SizedBox(height: 50),
              Form(
                key: controller.formKeyUpdate,
                child: Container(
                  // padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: controller.first_name,
                        validator: (value) => TValidator.validationEmptyText(
                          "tFirstName".tr,
                          value,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_outlined),
                          labelText: "tFirstName".tr,
                          hintText: "tFirstName".tr,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      // SizedBox(height: tFormHeight -20,),
                      // TextFormField(
                      //   // controller: controller.lastName,
                      //   validator: (value) => TValidator.validationEmptyText("Prénom", value),
                      //   decoration: InputDecoration(
                      //       prefixIcon: Icon(Icons.person_outline_outlined),
                      //       labelText: TextApp.tLastName,
                      //       hintText: TextApp.tLastName,
                      //       border: OutlineInputBorder()
                      //   ),
                      // ),
                      /* SizedBox(height: tFormHeight -20,),
                        TextFormField(
                          controller: controller.last_name,
                          validator: (value) => TValidator.validationEmptyText("tLastName".tr, value),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person_outline_outlined),
                              labelText: "tLastName".tr,
                              hintText: "tLastName".tr,
                              border: OutlineInputBorder()
                          ),
                        ), */
                      SizedBox(height: tFormHeight - 20),
                      TextFormField(
                        controller: controller.email,
                        validator: (value) => TValidator.validateEmail(value),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email),
                          labelText: TextApp.tEmail,
                          hintText: TextApp.tEmail,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: tFormHeight - 20),
                      TextFormField(
                        controller: controller.phoneNumber,
                        validator: (value) =>
                            TValidator.validationPhoneNumber(value),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.numbers),
                          labelText: TextApp.tPhoneNo,
                          hintText: TextApp.tPhoneNo,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: ColorApp.tsecondaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: tFormHeight - 20),
                      TextFormField(
                        controller: controller.userAdress,
                        validator: (value) => TValidator.validationEmptyText(
                          "tUserAdress".tr,
                          value,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_on_rounded),
                          labelText: "tUserAdress".tr,
                          hintText: "tUserAdress".tr,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      // // Obx( ()=>),
                      // TextFormField(
                      //   // controller: controller.password,
                      //   validator: (value) => TValidator.validatePassword(value),
                      //   // obscureText: controller.hidePassword.value,
                      //   decoration: InputDecoration(
                      //
                      //     prefixIcon: Icon(Icons.fingerprint),
                      //     labelText: TextApp.tPassword,
                      //     hintText: TextApp.tPassword,
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(5),
                      //       borderSide: BorderSide(
                      //         color: ColorApp.tsecondaryColor,
                      //       ),
                      //     ),
                      //     // suffixIcon: IconButton(
                      //     //   onPressed: () =>controller.hidePassword.value = !controller.hidePassword.value ,
                      //     //   icon: Icon(controller.hidePassword.value?  Icons.visibility_off : Icons.visibility),
                      //     //
                      //     // )
                      //   ),
                      // ),
                      SizedBox(height: tFormHeight - 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              UpdateProfileController.instance.updateProfile(),
                          child: Text(TextApp.tModify.toUpperCase()),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            foregroundColor: ColorApp.tWhiteColor,
                            backgroundColor: ColorApp.tsecondaryColor,
                            side: BorderSide(color: ColorApp.tsecondaryColor),
                            padding: EdgeInsets.symmetric(
                              vertical: tButtonHeight,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: tFormHeight - 15),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
