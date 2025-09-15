import 'package:smart_admin/src/exeptions/firebase_auth_exception.dart';
import 'package:smart_admin/src/exeptions/firebase_exception.dart';
import 'package:smart_admin/src/exeptions/format_exception.dart';
import 'package:smart_admin/src/models/auth/role_enum.dart';
import 'package:smart_admin/src/screens/auth/login_screen.dart';
import 'package:smart_admin/src/screens/auth/verify_email_screen.dart';
import 'package:smart_admin/src/screens/tabs.dart';
import 'package:smart_admin/src/screens/welcome/onboarding_screen.dart';
import 'package:smart_admin/src/utils/loaders/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthentificationRepository extends GetxController {
  static AuthentificationRepository get instance => Get.find();

  // Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  final deviceStorage = GetStorage();
  var verificationId = ''.obs;
  var userData = {}.obs;

  /// Get Authenticated User Data
  User? get authUser => _auth.currentUser;

  void onReady() {
    // Remove the native splash screen
    //FlutterNativeSplash.remove();
    // Redirect to the appropriate screen
    screenRedirect();
  }

  Future<String?> getUserRole(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    return snapshot.data()?['userRole'];
  }

  Future<Map<String, dynamic>> getUserInfo(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    return snapshot.data()!;
  }

  screenRedirect() async {
    final user = _auth.currentUser;

    print(user);

    if (user != null) {
      await user
          .reload(); // pour s'assurer que les dernières infos sont chargées
      if (user.emailVerified) {
        try {
          // Récupération des données depuis la collection 'users'

          final role = await getUserRole(user.uid);

          if (role == RoleEnum.Role_1) {
            // Get.offAll(() => CustomBottomNavBar());
            Get.offAll(() => TabsScreen());
          } else {
            // Si l'utilisateur n'est pas un client, redirige vers une page de restriction
            TLoaders.errorSnackBar(
              title: "Accès refusé",
              message:
                  "Votre rôle n'est pas autorisé à accéder à cette application.",
            );
            await logout();
          }
        } catch (e) {
          print("Erreur lors de la récupération du rôle utilisateur : $e");
          Get.snackbar("Erreur", "Impossible de vérifier votre rôle.");
        }
      } else {
        await sendEmailVerification();
        // Email pas encore vérifié
        Get.to(() => VerifyEmailScreen(email: _auth.currentUser?.email));
      }
    } else {
      print("user info: null");
      print(deviceStorage.read('IsFirstTime'));

      deviceStorage.writeIfNull('IsFirstTime', true);

      deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(() => TabsScreen())
          : Get.offAll(() => OnboardingScreen());
    }
  }

  /// [EmailAuthentication] - LOGIN
  Future<UserCredential> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException code: ${e.code}"); // Ajout temporaire
      throw TFirebaseAuthException(e.code).message;
    } catch (e) {
      // final ex = SignUpWithEmailAndPasswordFailure();
      // print('EXCEPTION - ${ex.message}');
      // throw ex;
      throw 'Something went wrong. Please try again.';
    }
  }

  /// [EmailAuthentication] - REGISTER
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } catch (e) {
      // final ex = SignUpWithEmailAndPasswordFailure();
      // print('EXCEPTION - ${ex.message}');
      // throw ex;
      throw 'Something went wrong. Please try again.';
    }
  }

  /// [EmailAuthentication] - AUTH WITH PHONE
  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }

        // Handle other errors
      },
      codeSent: (verificationId, resendToken) {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId.value = verificationId;
      },
    );
    // try{
    //
    // }
    // // on FirebaseAuthException catch(e){
    // //   throw TFirebaseAuthException(e.code).message;
    // // }on FirebaseException catch(e){
    // //   throw TFirebaseException(e.code).message;
    // // }on TFormatException catch(_){
    // //   throw TFormatException();
    // // }
    // catch(e){
    //   // final ex = SignUpWithEmailAndPasswordFailure();
    //   // print('EXCEPTION - ${ex.message}');
    //   // throw ex;
    //   throw 'Something went wrong. Please try again.';
    //
    // }
  }

  /// [EmailAuthentication] - AUTH WITH PHONE
  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: this.verificationId.value,
        smsCode: otp,
      ),
    );
    return credentials.user != null ? true : false;
    // try{
    //
    // }on FirebaseAuthException catch(e){
    //   throw TFirebaseAuthException(e.code).message;
    // }on FirebaseException catch(e){
    //   throw TFirebaseException(e.code).message;
    // }on TFormatException catch(_){
    //   throw TFormatException();
    // } catch(e){
    //   // final ex = SignUpWithEmailAndPasswordFailure();
    //   // print('EXCEPTION - ${ex.message}');
    //   // throw ex;
    //   throw 'Something went wrong. Please try again.';
    //
    // }
  }

  /// [EmailAuthentication] - MAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on TFormatException catch (_) {
      throw TFormatException();
    } catch (e) {
      // final ex = SignUpWithEmailAndPasswordFailure();
      // print('EXCEPTION - ${ex.message}');
      // throw ex;
      throw 'Something went wrong. Please try again.';
    }
  }

  /// [EmailAuthentication] - FORGET PASSWORD
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on TFormatException catch (_) {
      throw TFormatException();
    } catch (e) {
      // final ex = SignUpWithEmailAndPasswordFailure();
      // print('EXCEPTION - ${ex.message}');
      // throw ex;
      throw 'Something went wrong. Please try again.';
    }
  }

  /// [GoogleAuthentication] - GOOGLE
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();
      //Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await userAccount?.authentication;
      // create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on TFormatException catch (_) {
      throw TFormatException();
    } catch (e) {
      // final ex = SignUpWithEmailAndPasswordFailure();
      // print('EXCEPTION - ${ex.message}');
      // throw ex;
      if (kDebugMode) print('Something went wrong. $e');
      // throw 'Something went wrong. Please try again.';
      return null;
    }
  }

  // Future<void> loginWithEmailAndPassword(String email, String password) async{
  //   try{
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);
  //   }on FirebaseAuthException catch(e){
  //
  //   }catch(e){}
  // }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on TFormatException catch (_) {
      throw TFormatException();
    } catch (e) {
      // final ex = SignUpWithEmailAndPasswordFailure();
      // print('EXCEPTION - ${ex.message}');
      // throw ex;
      throw 'Something went wrong. Please try again.';
    }
  }
}
