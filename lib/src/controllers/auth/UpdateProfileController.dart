import 'dart:ffi';

import 'package:smart_admin/src/models/auth/role_enum.dart';
import 'package:smart_admin/src/repository/user_repository.dart';
import 'package:smart_admin/src/screens/auth/verify_email_screen.dart';
import 'package:smart_admin/src/constants/images.dart';
import 'package:smart_admin/src/controllers/auth/UserController.dart';
import 'package:smart_admin/src/repository/authentification_repository.dart';
import 'package:smart_admin/src/utils/loaders/loaders.dart';
import 'package:smart_admin/src/utils/popups/full_screen_loader.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'UserController.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class UpdateProfileController extends GetxController {
  static UpdateProfileController get instance => Get.find();
  File? imageFile;
  RxString imageUrl = "".obs;
  RxString imagePath = "".obs;
  final RxBool isUploading = false.obs;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final ImagePicker _picker = ImagePicker();

  void onInit() {
    // email.text = localStorage.read("REMEMBER_ME_EMAIL");
    // password.text = localStorage.read("REMEMBER_ME_PASSWORD");
    super.onInit();
  }

  /// Variables

  final first_name = TextEditingController();
  final last_name = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final shopName = TextEditingController();
  final shopAdress = TextEditingController();
  final userAdress = TextEditingController();
  GlobalKey<FormState> formKeyUpdate = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var collection = FirebaseFirestore.instance.collection("users");
  final usercontroller = Get.put(UserController());

  /// Email and Password SignIn
  Future<void> updateProfile() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog("", ImageApp.tDocerAnimation);

      // Check Internet Connectivity
      // final isConnected = await NetworkManager.instance.isConnected();
      // if(!isConnected) return;

      // Form validation
      if (!formKeyUpdate.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      final newUser = {
        "fullName": first_name.text.trim(),
        "email": email.text.trim(),
        "phoneNumber": phoneNumber.text.trim(),
        "userAdress": userAdress.text.trim(),
        "profilePicture": imageUrl.value,
      };

      await collection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(newUser);

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      Get.back();

      TLoaders.successSnackBar(
        title: "Congrat !!!",
        message: "Profile modifié avec succès.",
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: "oH Snap", message: e.toString());
    }
  }

  /// Google SignIn Authentication
  Future<void> googleSignIn() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
        "Logging you in ...",
        ImageApp.tDocerAnimation,
      );

      // Check Internet Connectivity
      // final isConnected = await NetworkManager.instance.isConnected();
      // if(!isConnected) return;

      // Form Validation
      // if(!_formKey.currentState!.validate()) return;

      // Google Authentication
      final userCredentials = await AuthentificationRepository.instance
          .signInWithGoogle();

      // Save User Record
      await userController.saveUserRecord(userCredentials);
      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      AuthentificationRepository.instance.screenRedirect();
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();

      TLoaders.errorSnackBar(title: "oH Snap", message: e.toString());
    }
  }

  Future<void> _pickGalleryImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 675,
      maxWidth: 900,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      imagePath.value = pickedFile.path;
      uploadImage(imageFile!);
    }
    Get.back();
  }

  Future _pickImageCamera() async {
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
      imagePath.value = returnImage.path;
      uploadImage(imageFile!);
      /* 
      imageUrl = await uploadImage(imageFile!);
      print("#############################################################");
      print(imagePath);
      print("#############################################################"); */
    }
    Get.back();
  }

  Future<String> uploadImage(File file) async {
    try {
      isUploading.value = true;
      final storageRef = _storage.ref().child(
        'profiles/${DateTime.now().millisecondsSinceEpoch}',
      );
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      imageUrl.value = url;

      // Vider le cache
      await CachedNetworkImage.evictFromCache(url);

      return url;
    } catch (e) {
      print("Erreur d'upload: $e");
      rethrow;
    } finally {
      isUploading.value = false;
    }
  }

  void showImagePickerOption(BuildContext context) {
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
                      _pickGalleryImage();
                    },
                    child: Column(
                      children: [Icon(Icons.image, size: 70), Text("Gallery")],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageCamera();
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
}
