/* 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:car_rental_owner/src/constants/colors.dart';
import 'package:car_rental_owner/src/utils/helpers/helper_function.dart';
import 'package:car_rental_owner/src/utils/texts/text_custom.dart';

class CustomBottomNav2Bar extends StatelessWidget {
  CustomBottomNav2Bar({super.key});

  final controller = Get.put(CustomBottomNavBarController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => Theme(
          data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(color: ColorApp.tsecondaryPercent5Color),
          ),
          child: CurvedNavigationBar(
            color:
                THelperFunctions.isDarkMode(context)
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.onPrimaryContainer,
            buttonBackgroundColor: ColorApp.tsecondaryColor,
            backgroundColor: Colors.transparent,
            height: 60,
            index: controller.selectedIndex.value,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 300),
            items: <Widget>[
              Icon(Icons.home, size: 30),
              Icon(Icons.favorite_outline_rounded, size: 30),
              Icon(Icons.messenger_outline_outlined, size: 30),
              Icon(Icons.person_outline_rounded, size: 30),
            ],
            onTap: (index) {
              controller.selectedIndex.value = index;

              if (index == 0 || index == 1) {
                controller.loadUserFavorites();
              }
            },
          ),
        ),
      ),
      body: Obx(() {
        if (controller.user.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          return controller.screens[controller.selectedIndex.value];
        }
      }),
    );
  }
}

class CustomBottomNavBarController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final Rx<bool> isLoading = false.obs;
  final user = <String, dynamic>{}.obs;
  final auth = FirebaseAuth.instance.currentUser!;
  RxList<CarModel> allCars = <CarModel>[].obs;
  RxMap<String, bool> favoriteMap = <String, bool>{}.obs;
  final isloading = false.obs;
  final userController = Get.put(UserController());
  final _firebase = FirebaseFirestore.instance;
  final _carRepository = Get.put(CarRepository());

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
    loadUserFavorites();
    fetchCars();
  }

  void _getUserInfo() async {
    final data = await AuthentificationRepository.instance.getUserInfo(
      auth.uid,
    );
    if (data.isNotEmpty) {
      user.value = data;
    } else {
      print('No data');
    }
  }

  Future<void> fetchCars() async {
    isloading.value = true;

    try {
      final cars = await _carRepository.getAllCars();

      allCars.assignAll(cars);
    } catch (e) {
      Get.snackbar("Erreur", "Échec du chargement des voitures : $e");
    } finally {
      isloading.value = false;
    }
  }

  Future<void> loadUserFavorites() async {
    final userRef = await userController.getUserByUid(auth.uid);
    if (userRef == null) return;

    final favoriteDocs =
        await _firebase
            .collection('favorites')
            .where("userRef", isEqualTo: userRef)
            .get();
    favoriteMap.clear();
    for (final doc in favoriteDocs.docs) {
      final carRef = doc['carRef'] as DocumentReference;
      favoriteMap[carRef.id] = true;
    }
  }

  void addCarInFavorite(DocumentReference carRef) async {
    try {
      final userRef = userController.getUserByUid(auth.uid);

      if (userRef == null) {
        Get.snackbar("Erreur", "Utilisateur non trouvé.");
        return;
      }

      final carExisting =
          await _firebase
              .collection('favorites')
              .where("userRef", isEqualTo: userRef)
              .where("carRef", isEqualTo: carRef)
              .get();
      // On modifie tout de suite l'UI
      final isFavNow = carExisting.docs.isEmpty;

      // Mise à jour immédiate de l'état local (réactif avec Obx)
      favoriteMap[carRef.id] = isFavNow;

      if (isFavNow) {
        await _firebase.collection('favorites').add({
          "userRef": userRef,
          "carRef": carRef,
        });

        Get.snackbar("Ajout au favoris", 'Voiture ajoutée dans votre favoris.');
      } else {
        for (final doc in carExisting.docs) {
          await doc.reference.delete();
        }
        favoriteMap.remove(carRef.id);

        Get.snackbar("Succès", "Voiture retirée de vos favoris.");
      }
    } catch (error) {
      Get.snackbar("Erreur lors de l'ajout au favoris", error.toString());
    }
  }

  List<Widget> get screens => [
    HomePageScreen(userFullName: user['fullName'],userEmail: user['email'],
      userProfile: user['profilePicture'],),
    FavoriteScreen(),
    ChatListScreen(),
    ProfileScreen(
      userFullName: user['fullName'],
      userEmail: user['email'],
      userProfile: user['profilePicture'],
    ),
  ];
}
 */