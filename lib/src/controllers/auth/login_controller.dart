import 'package:smart_admin/src/constants/images.dart';
import 'package:smart_admin/src/controllers/auth/UserController.dart';
import 'package:smart_admin/src/models/auth/role_enum.dart';
import 'package:smart_admin/src/repository/authentification_repository.dart';
import 'package:smart_admin/src/repository/user_repository.dart';
import 'package:smart_admin/src/screens/auth/verify_email_screen.dart';
import 'package:smart_admin/src/utils/loaders/loaders.dart';
import 'package:smart_admin/src/utils/popups/full_screen_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final repository = Get.put(AuthentificationRepository());

  /// Variables
  final _firebaseMessaging = FirebaseMessaging.instance;
  final RxString _fcmToken = "".obs;
  final localStorage = GetStorage();
  final hidePassword = true.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();
  final userController = Get.put(UserController());
   final RxDouble userLatitude = 0.0.obs;
  final RxDouble userLontitude = 0.0.obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void onInit() {
    // email.text = localStorage.read("REMEMBER_ME_EMAIL");
    // password.text = localStorage.read("REMEMBER_ME_PASSWORD");
    super.onInit();
    getFcmToken();
    _getCurrentLocation();
  }

  Future<String> getFcmToken() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    _fcmToken.value = fcmToken!;
    print('FCM Token: $fcmToken');
    return fcmToken;
  }

    Future<void> _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    locationData = await location.getLocation();
    userLatitude.value = locationData.latitude!;
    userLontitude.value = locationData.longitude!;

    if (locationData.latitude == null || locationData.longitude == null) return;
  }

  /// Email and Password SignIn
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog("", ImageApp.tDocerAnimation);

      // Check Internet Connectivity
      // final isConnected = await NetworkManager.instance.isConnected();
      // if(!isConnected) return;

      // Form validation
      if (!formKeyLogin.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Save Data if Remember Me is selected

      localStorage.write("REMEMBER_ME_EMAIL", email.text.trim());
      localStorage.write("REMEMBER_ME_PASSWORD", password.text.trim());

      // if(remember.value){
      //   localStorage.write("REMEMBER_ME_EMAIL", email.text.trim());
      //   localStorage.write("REMEMBER_ME_PASSWORD", password.text.trim());
      // }

      // Login user using Email & Password Authentication
      final userCredentials = await AuthentificationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredentials.user!.uid)
          .update({"fcmToken": _fcmToken.value});

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      repository.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "oH Snap", message: e.toString());
      print(e.toString());
    }
  }

  /// Google SignIn Authentication
  Future<void> googleSignIn() async {
    try {
      TFullScreenLoader.openLoadingDialog("", ImageApp.tDocerAnimation);
      //  await _googleSignIn.disconnect();
       await getFcmToken();
       await _getCurrentLocation();

      final userCredentials = await AuthentificationRepository.instance
          .signInWithGoogle();

      // 🔒 Vérifie si l'utilisateur a annulé la connexion Google
      if (userCredentials == null || userCredentials.user == null) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: "Connexion annulée",
          message: "Aucune authentification Google détectée.",
        );
        return;
      }

      final user = userCredentials.user;
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();

      if (!userDoc.exists) {
        final newUser = {
          "uid": userCredentials.user!.uid,
          "fullName": userCredentials.user!.displayName ?? "",
          "email": userCredentials.user!.email ?? "",
          "phoneNumber": userCredentials.user!.phoneNumber ?? "",
          "userRole": RoleEnum.Role_1,
          "fcmToken": _fcmToken.value,
          "profilePicture": userCredentials.user!.photoURL ?? "",
          'geopoint': GeoPoint(userLatitude.value, userLontitude.value),
        };

        final userRepository = Get.put(UserRepository());
        await userRepository.saveUserRecord(newUser);
        TLoaders.successSnackBar(
          title: 'Félicitations',
          message:
              "Compte créé avec succès ! Vérifiez votre email pour continuer.",
        );
        Get.to(() => VerifyEmailScreen(email: email.text.trim()));
      }

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
        title: 'Bienvenue',
        message: "Content de vous revoir.",
      );

      AuthentificationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      print(e.toString());
      TLoaders.errorSnackBar(title: "Erreur", message: e.toString());
    }
  }
}
