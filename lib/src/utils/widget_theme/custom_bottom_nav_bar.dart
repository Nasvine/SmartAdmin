


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/* class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomBottomNavBarController());
    return Scaffold(
      body:  Obx(() =>controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        backgroundColor: THelperFunctions.isDarkMode(context)
            ? ColorApp.tBlackColor
            : ColorApp.tWhiteColor,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: ColorApp.tsecondaryColor, // couleur active
        unselectedItemColor: ColorApp.tSombreColor,
        onTap: (index) => controller.selectedIndex.value = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline_rounded),
            activeIcon: Icon(Icons.favorite),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger_outline_outlined),
            activeIcon: Icon(Icons.messenger),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      )),
    );
  }
}


class CustomBottomNavBarController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;
  final screens = [ HomePageScreen(userFullName: "",),
    FavoriteScreen(),
    ChatListScreen(),
   // ProfileScreen(userFullName: user[''],),
    
    ];
} */