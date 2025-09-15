import 'package:smart_admin/src/models/auth/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_admin/src/models/auth/role_enum.dart';
import 'package:smart_admin/src/repository/user_repository.dart';
import 'package:smart_admin/src/screens/auth/verify_email_screen.dart';
import 'package:smart_admin/src/constants/images.dart';
import 'package:smart_admin/src/controllers/auth/UserController.dart';
import 'package:smart_admin/src/repository/authentification_repository.dart';
import 'package:smart_admin/src/utils/loaders/loaders.dart';
import 'package:smart_admin/src/utils/popups/full_screen_loader.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());
  RxList<UserModel> allUsers = <UserModel>[].obs;

  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  /// Fetch user record
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
      profileLoading.value = false;
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  /// Save user Record from any Registration provider
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      if (userCredentials != null) {
        // Convert Name to First and Last Name
        /*  final nameParts = UserModel.nameParts(
          userCredentials.user!.displayName ?? '',
        ); */
        // final username = UserModel.generateUsername(userCredentials.user!.displayName ?? '');

        // Map Data
        final user = {
          'uid': userCredentials.user!.uid,
          'fullName': userCredentials.user!.displayName ?? "",
          //lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
          'email': userCredentials.user!.email ?? "",
          'phoneNumber': userCredentials.user!.phoneNumber ?? "",
          'userRole': RoleEnum.Role_3,
          'profilePicture': userCredentials.user!.photoURL ?? "",
        };

        // Save user data
        await userRepository.saveUserRecord(user);
      }
    } catch (e) {
      TLoaders.warningSnackBar(
        title: "Data not Found",
        message:
            'Something went wrong saving your information. You can resign your data in your profile.',
      );
    }
  }

  /// Récupère un UTILISATEUR depuis une DocumentReference
  Future<UserModel?> getUserByRef(DocumentReference ref) async {
    try {
      // Vérifie si la marque est déjà dans la liste
      final id = ref.id;
      final existing = allUsers.firstWhereOrNull((b) => b.uid == id);
      if (existing != null) return existing;

      // Sinon on la récupère depuis Firestore
      final snapshot = await ref
          .withConverter<UserModel>(
            fromFirestore: (snap, _) => UserModel.fromSnapshot(snap),
            toFirestore: (user, _) => user.toJson(),
          )
          .get();

      final user = snapshot.data();
      if (user != null) {
        allUsers.add(user); // Mise en cache locale
      }

      return user;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Erreur Brand', message: e.toString());
      return null;
    }
  }

  DocumentReference? getUserByUid(String id) {
    try {
      final ref = FirebaseFirestore.instance.collection('users').doc(id);
      return ref;
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Erreur de récupération de la référence',
        message: e.toString(),
      );
      return null;
    }
  }
}
