import 'package:cached_network_image/cached_network_image.dart';
import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/models/auth/user_model.dart';
import 'package:smart_admin/src/screens/tabs.dart';
import 'package:smart_admin/src/screens/users/user_list.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/loaders/loaders.dart';
import 'package:smart_admin/src/utils/texts/button_custom.dart';
import 'package:smart_admin/src/utils/texts/dropdown_formfield_custom.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';
import 'package:smart_admin/src/utils/texts/text_form_field_simple_custom.dart';
import 'package:smart_admin/src/utils/validators/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserCreateScreen extends StatefulWidget {
  const UserCreateScreen({super.key, required this.userId});
  final String userId;

  @override
  State<UserCreateScreen> createState() => _UserCreateScreenState();
}

class _UserCreateScreenState extends State<UserCreateScreen> {
  final firebase = FirebaseFirestore.instance;
  final userNameController = TextEditingController();
  final userEmailController = TextEditingController();
  final userAdresseController = TextEditingController();
  final userPhoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? selectedRole;
  String? userImage;
  List<String> carImageUrls = [];
  List<File> selectedCarImages = [];
  String? companyAdresse;
  bool isUploading = false;
  bool isValidated = false;

  File? imageFile;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  List<String> userRoles = ['Super Admin', 'Admin', 'Client', 'Deliver'];

  /*  */

  void fetchDataUser() async {
    if (widget.userId == "") return;
    final data = await firebase.collection('users').doc(widget.userId).get();
    print(data);

    if (data.exists) {
      final verifyItem = UserModel.fromSnapshot(data);
      setState(() {
        userNameController.text = verifyItem.fullName;
        userAdresseController.text = verifyItem.userAdress;
        userEmailController.text = verifyItem.email;
        userPhoneController.text = verifyItem.phoneNumber;
        userImage = verifyItem.profilePicture;
        selectedRole = verifyItem.userRole;
      });
    }
  }

  /* Management Principale Images */

  Future<void> _pickGalleryCarImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 675,
      maxWidth: 900,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      uploadCarImage(imageFile!);
    }
    Get.back();
  }

  Future _pickImageCarCamera() async {
    // final ImagePicker picker = ImagePicker();
    final returnImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 900,
    );
    // final LostDataResponse response = await picker.retrieveLostData();
    if (returnImage == null) return;

    ///load result and file details
    if (returnImage != null) {
      imageFile = File(returnImage.path);
      uploadCarImage(imageFile!);
      Get.back();
    }
  }

  Future<String> uploadCarImage(File file) async {
    try {
      setState(() {
        isUploading = true;
      });

      final storageRef = _storage.ref().child(
        'users/${DateTime.now().millisecondsSinceEpoch}',
      );
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      setState(() {
        userImage = url;
      });

      // Vider le cache
      await CachedNetworkImage.evictFromCache(url);

      return url;
    } catch (e) {
      print("Erreur d'upload: $e");
      rethrow;
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  void showImagePickerCarOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 6,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickGalleryCarImage();
                    },
                    child: Column(
                      children: [Icon(Icons.image, size: 70), Text("Gallery")],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageCarCamera();
                    },
                    child: Column(
                      children: [
                        Icon(Icons.camera_enhance, size: 70),
                        Text("Camera"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    fetchDataUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            LineAwesomeIcons.angle_left_solid,
            color: THelperFunctions.isDarkMode(context)
                ? ColorApp.tWhiteColor
                : ColorApp.tBlackColor,
          ),
          onPressed: () => Get.offAll(() => const UserListScreen()),
        ),
        title: TextCustom(
          TheText: widget.userId == "" ? "tAddUser".tr : "tUpdUser".tr,
          TheTextSize: 14,
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextCustom(
                      TheText: "tUserImage".tr,
                      TheTextSize: 14,
                      TheTextFontWeight: FontWeight.bold,
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Positioned(
                  top: 40,
                  left: 90,
                  bottom: 30,
                  child: GestureDetector(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.black,
                          child: userImage == '' ||  userImage == null
                              ? CircleAvatar(
                                  radius: 80,
                                  backgroundImage: AssetImage(
                                    'assets/images/cover.jpg',
                                  ),
                                )
                              : ClipOval(
                                  child: Image.network(
                                    width: 150,
                                    height: 150,
                                    userImage!,
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
                        if (isUploading)
                          const Positioned.fill(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
                    onTap: () {
                      showImagePickerCarOption(context);
                    },
                  ),
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextCustom(
                      TheText: "tUserName".tr,
                      TheTextSize: 14,
                      TheTextFontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormFieldSimpleCustom(
                  keyboardType: TextInputType.text,
                  obscureText: false,
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
                  controller: userNameController,
                  labelText: widget.userId != ""
                      ? userNameController.text
                      : "tUserName".tr,
                  labelStyleColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  hintText: widget.userId != ""
                      ? userNameController.text
                      : "tUserName".tr,
                  hintStyleColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,

                  validator: (value) =>
                      TValidator.validationEmptyText("tUserName".tr, value),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextCustom(
                      TheText: "tUserEmail".tr,
                      TheTextSize: 14,
                      TheTextFontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormFieldSimpleCustom(
                  keyboardType: TextInputType.text,
                  obscureText: false,
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
                  controller: userEmailController,
                  labelText: widget.userId != ""
                      ? userNameController.text
                      : "tUserEmail".tr,
                  labelStyleColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  hintText: widget.userId != ""
                      ? userNameController.text
                      : "tUserEmail".tr,
                  hintStyleColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,

                  validator: (value) =>
                      TValidator.validationEmptyText("tUserEmail".tr, value),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextCustom(
                      TheText: "tUserAdresse".tr,
                      TheTextSize: 14,
                      TheTextFontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormFieldSimpleCustom(
                  keyboardType: TextInputType.text,
                  obscureText: false,
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
                  controller: userAdresseController,
                  labelText: widget.userId != ""
                      ? userAdresseController.text
                      : "tUserAdresse".tr,
                  labelStyleColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  hintText: widget.userId != ""
                      ? userAdresseController.text
                      : "tUserAdresse".tr,
                  hintStyleColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,

                  validator: (value) =>
                      TValidator.validationEmptyText("tUserAdresse".tr, value),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextCustom(
                      TheText: "tUserPhone".tr,
                      TheTextSize: 14,
                      TheTextFontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormFieldSimpleCustom(
                  keyboardType: TextInputType.number,
                  obscureText: false,
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
                  controller: userPhoneController,
                  labelText: widget.userId != ""
                      ? userPhoneController.text
                      : "tUserPhone".tr,
                  labelStyleColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  hintText: widget.userId != ""
                      ? userPhoneController.text
                      : "tUserPhone".tr,
                  hintStyleColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,

                  validator: (value) => TValidator.validationPhoneNumber(value),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextCustom(
                      TheText: "tUserRole".tr,
                      TheTextSize: 14,
                      TheTextFontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                /* tUserRole */
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: THelperFunctions.isDarkMode(context)
                            ? ColorApp.tSombreColor
                            : ColorApp.tBlackColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: THelperFunctions.isDarkMode(context)
                            ? ColorApp.tSombreColor
                            : ColorApp.tBlackColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: THelperFunctions.isDarkMode(context)
                            ? ColorApp.tSombreColor
                            : ColorApp.tBlackColor,
                      ),
                    ),
                  ),
                  value: selectedRole,
                  hint: Text('tUserRole'.tr),
                  items: userRoles.map((value) {
                    return DropdownMenuItem(child: Text(value), value: value);
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                  validator: (value) =>
                      TValidator.validationEmptyText("tUserRoleText".tr, value),
                ),

                const SizedBox(height: 10),
                isValidated
                    ? CircularProgressIndicator(color: ColorApp.tPrimaryColor)
                    : ButtonCustom(
                        text: widget.userId != null
                            ? "tUpdBtn".tr
                            : "tAddBtn".tr,
                        textSize: 15,
                        buttonBackgroundColor: ColorApp.tsecondaryColor,
                        onPressed: () async {
                          setState(() {
                            isValidated = true;
                          });
                          if (!formKey.currentState!.validate()) {
                            setState(() {
                              isValidated = false;
                            });
                            return;
                          }
                          final userItem = UserModel(
                            fullName: userNameController.text.trim(),
                            email: userEmailController.text.trim(),
                            phoneNumber: userPhoneController.text.trim(),
                            userRole: selectedRole!,
                            userAdress: userAdresseController.text.trim(),
                            isAvailable: true,
                            geopoint: GeoPoint(0, 0),
                            profilePicture: userImage,
                          );

                          if (widget.userId != null) {
                            await firebase
                                .collection('users')
                                .doc(widget.userId)
                                .update(userItem.toJson());
                            setState(() {
                              isValidated = false;
                            });
                            TLoaders.successSnackBar(
                              title: 'Congratulations',
                              message: "tMessageUpdUser".tr,
                            );
                          } else {
                            setState(() {
                              isValidated = true;
                            });
                            await firebase
                                .collection('users')
                                .add(userItem.toJson());
                            TLoaders.successSnackBar(
                              title: 'Congratulations',
                              message: "tMessageAddUser".tr,
                            );
                            setState(() {
                              isValidated = false;
                            });
                          }
                          Get.offAll(() => const UserListScreen());
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
