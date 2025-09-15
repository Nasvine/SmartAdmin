import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/constants/texts.dart';
import 'package:smart_admin/src/models/auth/user_model.dart';
import 'package:smart_admin/src/screens/tabs.dart';
import 'package:smart_admin/src/screens/users/user_create.dart';
import 'package:smart_admin/src/screens/verify_account/verify_account.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/loaders/loaders.dart';
import 'package:smart_admin/src/utils/texts/button_custom_outlined.dart';
import 'package:smart_admin/src/utils/texts/button_custom_outlined_icon.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';
import 'package:smart_admin/src/utils/texts/text_form_field_simple_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final authId = FirebaseAuth.instance.currentUser!.uid;
  String _searchQuery = '';
  Timer? _debounce;

  TextEditingController searchController = TextEditingController();

  Stream<List<UserModel>> fetchUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((document) => UserModel.fromSnapshot(document))
              .toList(),
        );
  }

  void _onRemoveCar(String userId) async {
    if (userId.isEmpty) return;

    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        TLoaders.warningSnackBar(
          title: 'Erreur',
          message: "Utilisateur introuvable.",
        );
        return;
      }

      final data = docSnapshot.data()!;
      final String? mainImage = data['profilePicture'];

      // Supprimer l'image principale
      if (mainImage != null && mainImage.isNotEmpty) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(mainImage);
          await ref.delete();
        } catch (e) {
          print("Erreur suppression image principale : $e");
        }
      }

      // Supprimer le document Firestore
      await docRef.delete();

      // Afficher le succès
      TLoaders.successSnackBar(
        title: 'Félicitations',
        message: "tMessageDltUser".tr,
      );
    } catch (e) {
      print("Erreur suppression utitlisateur : $e");
      TLoaders.warningSnackBar(title: 'Erreur', message: e.toString());
    }
  }

  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
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
          onPressed: () => Get.offAll(() => const TabsScreen(initialIndex: 0)),
        ),
        title: TextCustom(TheText: "tUserLists".tr, TheTextSize: 14),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    child: TextFormFieldSimpleCustom(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();

                        _debounce = Timer(
                          const Duration(milliseconds: 700),
                          () {
                            setState(() {
                              _searchQuery = value!.toLowerCase();
                            });
                          },
                        );
                      },
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
                      controller: searchController,
                      labelText: 'tSearchUser'.tr,
                      labelStyleColor: THelperFunctions.isDarkMode(context)
                          ? ColorApp.tWhiteColor
                          : ColorApp.tBlackColor,
                      hintText: 'tSearchUser'.tr,
                      hintStyleColor: THelperFunctions.isDarkMode(context)
                          ? ColorApp.tWhiteColor
                          : ColorApp.tBlackColor,
                      prefixIcon: Icon(
                        Icons.search_outlined,
                        color: THelperFunctions.isDarkMode(context)
                            ? ColorApp.tWhiteColor
                            : ColorApp.tBlackColor,
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: THelperFunctions.isDarkMode(context)
                                    ? ColorApp.tWhiteColor
                                    : ColorApp.tBlackColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => UserCreateScreen(userId: ""));
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorApp.tPrimaryColor,
                    ),
                    child: Center(
                      child: Icon(Icons.add, color: ColorApp.tWhiteColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder(
              stream: fetchUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      children: [const Text("Aucun utilisateur trouvé(e)")],
                    ),
                  );
                }

                final allUsers = snapshot.data!;
                final filteredUsers = allUsers.where((user) {
                  return user.fullName.toLowerCase().contains(_searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final UserModel = filteredUsers[index];
                    return Dismissible(
                      key: ValueKey(UserModel),
                      onDismissed: (direction) async {
                        if (UserModel.ref!.id == authId) {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Confirmation"),
                              content: Text("DeleteUserMessage".tr),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
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
                            _onRemoveCar(UserModel.ref!.id);
                          }
                        } else {
                          TLoaders.errorSnackBar(
                            title: 'ImpossibleActionDelete'.tr,
                            message: "ImpossibleActionMessageDelete".tr,
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 20,
                            left: 5,
                            right: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  UserModel.profilePicture == ""
                                      ? CircleAvatar(
                                          radius: 25,
                                          backgroundImage: AssetImage(
                                            "assets/images/cover.jpg",
                                          ),
                                        )
                                      : Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: Image.network(
                                              UserModel.profilePicture!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                  SizedBox(width: 10),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextCustom(
                                          TheText: UserModel.fullName,
                                          TheTextFontWeight: FontWeight.bold,
                                          TheTextSize: 12,
                                        ),
                                        TextCustom(
                                          TheText: UserModel.userRole,
                                          TheTextFontWeight: FontWeight.normal,
                                          TheTextSize: 12,
                                        ),
                                        TextCustom(
                                          TheText: UserModel.email,
                                          TheTextFontWeight: FontWeight.normal,
                                          TheTextSize: 12,
                                        ),
                                        TextCustom(
                                          TheText: UserModel.phoneNumber,
                                          TheTextFontWeight: FontWeight.normal,
                                          TheTextSize: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Get.to(
                                        () => UserCreateScreen(
                                          userId: UserModel.ref!.id,
                                        ),
                                      );
                                    },
                                    icon: Icon(LineAwesomeIcons.edit),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                    /* CarItem(
                        image: UserModel.link,
                        name: UserModel.name,
                        onEdit: () {
                          Get.to(
                            () =>  CarCreateScreen(
                              carId: UserModel.ref!.id
                            ),
                          );
                        },
                      ),
                    ); */
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
