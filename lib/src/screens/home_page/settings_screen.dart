import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/constants/sizes.dart';
import 'package:smart_admin/src/screens/tabs.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/loaders/loaders.dart';
import 'package:smart_admin/src/utils/texts/button_custom.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import "package:smart_admin/src/models/banner_model.dart";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final firebase = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  List<String> imageUrls = [];
  List<File> selectedImages = [];
  bool isUploading = false;
  bool isValidated = false;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String clientBannerUid = "";
  /* Management Images Gallery */

  Future<void> _pickGalleryBannerImages() async {
    Get.back();
    try {
      final pickedFiles = await _picker.pickMultiImage(
        maxHeight: 675,
        maxWidth: 900,
      );
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          isUploading = true;
        });
        selectedImages.clear();

        for (final image in pickedFiles) {
          final file = File(image.path);
          selectedImages.add(file);
          final url = await uploadBannerImages(file);
          imageUrls.add(url);
        }
        print("Images uploadées : $imageUrls");
      }
    } catch (e) {
      print("Erreur lors du choix d'images : $e");
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  Future<String> uploadBannerImages(File file) async {
    try {
      setState(() {
        isUploading = true;
      });

      final storageRef = _storage.ref().child(
        'banners/${DateTime.now().millisecondsSinceEpoch}',
      );
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();

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

  void showImagePickerCarOptions(BuildContext context) {
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
                      _pickGalleryBannerImages();
                    },
                    child: Column(
                      children: [Icon(Icons.image, size: 70), Text("Gallery")],
                    ),
                  ),
                ),
                /*  Expanded(
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
                ), */
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteUploadedImage(String imageUrl) async {
    try {
      final ref = await _storage.refFromURL(imageUrl);
      await ref.delete(); // Supprimer depuis Firebase Storage

      setState(() {
        imageUrls.remove(imageUrl); // Supprimer localement
      });

      print("Image supprimée : $imageUrl");
    } catch (e) {
      print("Erreur suppression image : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la suppression de l'image.")),
      );
    }
  }

  void fetchClientBanners() async {
    final data = await firebase
        .collection('banners')
        .where('application', isEqualTo: "Client")
        .limit(1)
        .get();
    print(data);

    if (data.docs.isNotEmpty) {
      final verifyItem = BannerModel.fromSnapshot(data.docs.first);
      setState(() {
        imageUrls = verifyItem.images;
        clientBannerUid = verifyItem.uuid!;
      });
    }
  }

  @override
  void initState() {
    fetchClientBanners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.offAll(() => TabsScreen(initialIndex: 0)),
          icon: Icon(
            LineAwesomeIcons.angle_left_solid,
            color: THelperFunctions.isDarkMode(context)
                ? ColorApp.tWhiteColor
                : ColorApp.tBlackColor,
          ),
        ),
        centerTitle: true,
        title: TextCustom(
          TheText: "Paramètre",
          TheTextSize: 14,
          TheTextFontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: tFormHeight),

            Container(
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
                      TextCustom(
                        TheText: 'Change de mode',
                        TheTextSize: 13,
                        TheTextFontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        Get.changeTheme(
                          Get.isDarkMode ? ThemeData.light() : ThemeData.dark(),
                        );
                      });
                    },
                    icon: Icon(
                      isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextCustom(
                  TheText: "tClientBannerGalerieImage".tr,
                  TheTextSize: 14,
                  TheTextFontWeight: FontWeight.bold,
                ),
              ],
            ),

            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 160,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 1,
                  color: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  showImagePickerCarOptions(context);
                },
                child: isUploading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: ColorApp.tPrimaryColor,
                        ),
                      )
                    : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera),
                            SizedBox(width: 5),
                            Text("tClientBannerGalerieImageText".tr),
                          ],
                        ),
                      ),
              ),
            ),
            imageUrls.isEmpty
                ? const SizedBox.shrink()
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    itemCount: imageUrls.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 3 images par ligne
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemBuilder: (context, index) {
                      final imageUrl = imageUrls[index];

                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () async {
                                await deleteUploadedImage(imageUrl);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

            const SizedBox(height: 10),
            isValidated
                ? CircularProgressIndicator()
                : ButtonCustom(
                    buttonBackgroundColor: ColorApp.tSecondaryColor,
                    onPressed: () async {
                      try {
                        setState(() {
                          isValidated = true;
                        });
                        final clientBanner = BannerModel(
                          application: "Client",
                          images: imageUrls,
                          userId: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid),
                        );
                        if (clientBannerUid == '') {
                          await firebase
                              .collection('banners')
                              .add(clientBanner.toJson());
                          setState(() {
                            isValidated = false;
                          });
                          TLoaders.successSnackBar(
                            title: "Bannières ajouté(e)s avec succès.",
                          );
                        } else {
                          await firebase
                              .collection('banners')
                              .doc(clientBannerUid)
                              .update(clientBanner.toJson());
                          setState(() {
                            isValidated = false;
                          });
                          TLoaders.successSnackBar(
                            title: "Bannière mise à jour avec succès.",
                          );
                        }
                      } catch (e) {
                        setState(() {
                          isValidated = false;
                        });
                        TLoaders.errorSnackBar(title: "Erreur $e");
                      }
                    },
                    text: clientBannerUid == ''? 'Ajouter' : 'Mettre à jour',
                    textSize: 13,
                  ),
          ],
        ),
      ),
    );
  }
}
