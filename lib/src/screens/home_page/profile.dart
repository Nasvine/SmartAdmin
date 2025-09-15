import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/constants/images.dart';
import 'package:smart_admin/src/constants/sizes.dart';
import 'package:smart_admin/src/controllers/auth/avis_contoller.dart';
import 'package:smart_admin/src/models/auth/user_model.dart';
import 'package:smart_admin/src/repository/authentification_repository.dart';
import 'package:smart_admin/src/repository/user_repository.dart';
import 'package:smart_admin/src/screens/auth/login_screen.dart';
import 'package:smart_admin/src/screens/auth/update_profile_screen.dart';
import 'package:smart_admin/src/screens/gain.dart';
import 'package:smart_admin/src/screens/home_page/settings_screen.dart';
import 'package:smart_admin/src/screens/settings/about_page.dart';
import 'package:smart_admin/src/screens/settings/policy_page.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:text_custom/text_custom.dart';
import 'package:google_sign_in/google_sign_in.dart';


final _auth = FirebaseAuth.instance.currentUser!;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.userFullName,
    required this.userEmail,
  });

  final String userFullName;
  final String userEmail;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final repository = Get.put(AuthentificationRepository());
  final user_repository = Get.put(UserRepository());
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> deleteUserAccount() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;

      try {
        // Supprimer les données de Firestore (ex: collection users)
        await FirebaseFirestore.instance.collection('users').doc(uid).delete();

        // Supprimer le compte de Firebase Auth
        await user.delete();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          // Il faut réauthentifier l'utilisateur
          throw FirebaseAuthException(
            code: 'requires-recent-login',
            message: 'Vous devez vous reconnecter pour supprimer votre compte.',
          );
        } else {
          rethrow;
        }
      }
    }
  }

  void showAvisModal(BuildContext context) async {
    final AvisController avisController = Get.put(AvisController());
    await avisController.loadUserAvis(); // Charge l'avis existant s'il y en a

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                avisController.existingAvisDoc != null
                    ? "Modifier votre avis"
                    : "Donnez votre avis",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // ⭐ Étoiles
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () =>
                          avisController.selectedStars.value = index + 1,
                      icon: Icon(
                        index < avisController.selectedStars.value
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 30,
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: 20),

              // 💬 Commentaire
              TextField(
                controller: avisController.commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Commentaire (optionnel)",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              // 📤 Bouton d’envoi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: avisController.submitAvis,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorApp.tsecondaryColor,
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    avisController.existingAvisDoc != null
                        ? "Modifier mon avis"
                        : "Envoyer mon avis",
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      body: StreamBuilder<UserModel>(
        stream: user_repository.fetchUserDetailsRealTime(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Une erreur est survenue: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == UserModel.empty()) {
            return Center(child: Text('Aucun utilisateur trouvé.'));
          } else {
            // Affiche les détails de l'utilisateur
            final user = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(tDefaultSize - 20),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: user.profilePicture == null
                                ? Image(image: AssetImage(ImageApp.tCover))
                                : Image.network(
                                    user.profilePicture!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        /*   Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: ColorApp.tsecondaryColor,
                            ),
                            child: Icon(Icons.edit),
                          ),
                        ), */
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${user.fullName}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${user.email}",
                      style: TextStyle(fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () =>
                            Get.to(() => UpdateUserProfileScreen(user: user)),
                        child: Text(
                          "tEditProfile".tr,
                          style: TextStyle(color: ColorApp.tWhiteColor),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorApp.tsecondaryColor,
                          side: BorderSide.none,
                          shape: StadiumBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () =>
                          Get.to(() => UpdateUserProfileScreen(user: user)),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: THelperFunctions.isDarkMode(context)
                                ? ColorApp.tSombreColor
                                : ColorApp.tBlackColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  color: ColorApp.tsecondaryColor,
                                ),
                                TextCustom(
                                  TheText: 'Edit Profile',
                                  TheTextSize: 13,
                                  TheTextFontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: ColorApp.tsecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    /*  SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => Get.to(() => GainScreen()),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: THelperFunctions.isDarkMode(context)
                                ? ColorApp.tSombreColor
                                : ColorApp.tBlackColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.payments,
                                  color: ColorApp.tsecondaryColor,
                                ),
                                TextCustom(
                                  TheText: 'Mon Gains',
                                  TheTextSize: 13,
                                  TheTextFontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: ColorApp.tsecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ), */
                    SizedBox(height: 10),

                    GestureDetector(
                      onTap: () => Get.to(() => SettingsScreen()),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: THelperFunctions.isDarkMode(context)
                                ? ColorApp.tSombreColor
                                : ColorApp.tBlackColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.settings,
                                  color: ColorApp.tsecondaryColor,
                                ),
                                TextCustom(
                                  TheText: 'Settings',
                                  TheTextSize: 13,
                                  TheTextFontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: ColorApp.tsecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    /*  SizedBox(height: 10),
                    GestureDetector(
                      onTap: (){} /* => Get.to(() => const OrdersScreen()) */,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: THelperFunctions.isDarkMode(context)
                                ? ColorApp.tSombreColor
                                : ColorApp.tBlackColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.history_toggle_off_outlined,
                                  color: ColorApp.tsecondaryColor,
                                ),
                                TextCustom(
                                  TheText: 'Historique des réservations',
                                  TheTextSize: 13,
                                  TheTextFontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: ColorApp.tsecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ), */
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => Get.to(() => AboutOwnerPage()),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: THelperFunctions.isDarkMode(context)
                                ? ColorApp.tSombreColor
                                : ColorApp.tBlackColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.info,
                                  color: ColorApp.tsecondaryColor,
                                ),
                                TextCustom(
                                  TheText: "tAbout".tr,
                                  TheTextSize: 13,
                                  TheTextFontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: ColorApp.tsecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => Get.to(() => PrivacyPolicyOwnerPage()),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: THelperFunctions.isDarkMode(context)
                                ? ColorApp.tSombreColor
                                : ColorApp.tBlackColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.privacy_tip,
                                  color: ColorApp.tsecondaryColor,
                                ),
                                TextCustom(
                                  TheText: "tPolicy".tr,
                                  TheTextSize: 13,
                                  TheTextFontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: ColorApp.tsecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => showAvisModal(context),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: THelperFunctions.isDarkMode(context)
                                ? ColorApp.tSombreColor
                                : ColorApp.tBlackColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  LineAwesomeIcons.notes_medical_solid,
                                  color: ColorApp.tsecondaryColor,
                                ),
                                TextCustom(
                                  TheText: "tGiveAvis".tr,
                                  TheTextSize: 13,
                                  TheTextFontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: ColorApp.tsecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              "Confirmation",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: const Text(
                              "Voulez-vous vraiment vous déconnecter ?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Annuler"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  "Supprimer",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          try {
                            await _googleSignIn.disconnect();
                            repository.logout();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Erreur lors de la suppression : $e",
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: THelperFunctions.isDarkMode(context)
                                ? ColorApp.tSombreColor
                                : ColorApp.tBlackColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.logout_outlined,
                                  color: ColorApp.tsecondaryColor,
                                ),
                                TextCustom(
                                  TheText: 'Déconnexion',
                                  TheTextSize: 13,
                                  TheTextFontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: ColorApp.tsecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              "Confirmation",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: const Text(
                              "Voulez-vous vraiment supprimer votre compte ?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Annuler"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  "Supprimer",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          try {
                            await deleteUserAccount();
                            // Rediriger vers la page de login
                            Get.offAll(() => LoginScreen());
                          } catch (e) {
                            if (e is FirebaseAuthException &&
                                e.code == 'requires-recent-login') {
                              // Demander une reconnexion ou rediriger vers une page de login
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Reconnectez-vous pour supprimer votre compte.',
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erreur: ${e.toString()}'),
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: THelperFunctions.isDarkMode(context)
                                ? ColorApp.tSombreColor
                                : ColorApp.tBlackColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: ColorApp.tsecondaryColor,
                                ),
                                TextCustom(
                                  TheText: 'Supprimer mon compte',
                                  TheTextSize: 13,
                                  TheTextFontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: ColorApp.tsecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
