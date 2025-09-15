import 'package:smart_admin/src/constants/images.dart';
import 'package:smart_admin/src/utils/widget_theme/circle_icon_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';

class CustomTabview extends StatelessWidget {
  const CustomTabview({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomTabviewController());
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return DefaultTabController(
      length: 3,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TabBar
            TabBar(
              labelColor: ColorApp.tsecondaryColor,
              unselectedLabelColor: THelperFunctions.isDarkMode(context)
                  ? ColorApp.tSombreColor
                  : ColorApp.tBlackColor,
              indicatorColor: ColorApp.tsecondaryColor,
              tabs: [
                Tab(text: "About"),
                Tab(text: "Gallery"),
                Tab(text: "Reviews"),
              ],
            ),

            // TabBarView
            SizedBox(
              height:
                  300, // Donne une hauteur suffisante pour le scroll interne
              child: TabBarView(
                children: [
                  // About tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          TheText: 'Rent Partner',
                          TheTextSize: THelperFunctions.w(context, 0.04),
                          TheTextFontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage(
                                "assets/images/profile.jpg",
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Jenny Doe",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Owner",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Spacer(),
                            IconButton(
                              icon: CircleIconCustom(
                                isDark: isDark,
                                headerIcon1: Icons.messenger_outline_rounded,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: CircleIconCustom(
                                isDark: isDark,
                                headerIcon1: Icons.call,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextCustom(
                          TheText: 'Description',
                          TheTextSize: THelperFunctions.w(context, 0.04),
                          TheTextFontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry...",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  // Gallery tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TextCustom(
                              TheText: "Gallery",
                              TheTextSize: THelperFunctions.w(context, 0.04),
                              TheTextFontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: [
                            Image(
                              image: AssetImage(ImageApp.car1),
                              fit: BoxFit.cover,
                            ),
                            Image(
                              image: AssetImage(ImageApp.car1),
                              fit: BoxFit.cover,
                            ),
                            Image(
                              image: AssetImage(ImageApp.car1),
                              fit: BoxFit.cover,
                            ),
                            Image(
                              image: AssetImage(ImageApp.car1),
                              fit: BoxFit.cover,
                            ),
                            Image(
                              image: AssetImage(ImageApp.car1),
                              fit: BoxFit.cover,
                            ),
                            Image(
                              image: AssetImage(ImageApp.car1),
                              fit: BoxFit.cover,
                            ),
                            Image(
                              image: AssetImage(ImageApp.car1),
                              fit: BoxFit.cover,
                            ),
                            Image(
                              image: AssetImage(ImageApp.car1),
                              fit: BoxFit.cover,
                            ),
                            Image(
                              image: AssetImage(ImageApp.car1),
                              fit: BoxFit.cover,
                            ),
                            Image(
                              image: AssetImage(ImageApp.car1),
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Review tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          TheText: 'Reviews',
                          TheTextSize: THelperFunctions.w(context, 0.04),
                          TheTextFontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: THelperFunctions.h(context, 0.04)),
                        Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: AssetImage(
                                    "assets/images/profile.jpg",
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextCustom(
                                      TheText: "Max Halvart",
                                      TheTextSize: THelperFunctions.w(
                                        context,
                                        0.03,
                                      ),
                                      TheTextFontWeight: FontWeight.bold,
                                    ),
                                    TextCustom(
                                      TheText: "Ceo at Car Station",
                                      TheTextSize: THelperFunctions.w(
                                        context,
                                        0.03,
                                      ),
                                      TheTextFontWeight: FontWeight.normal,
                                      TheTextColor: ColorApp.tSombreColor,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  spacing: 3,
                                  children: [
                                    Icon(
                                      Icons.access_time_outlined,
                                      size: THelperFunctions.w(context, 0.04),
                                    ),
                                    TextCustom(
                                      TheText: "09 March 2025",
                                      TheTextSize: THelperFunctions.w(
                                        context,
                                        0.03,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: THelperFunctions.h(context, 0.04)),
                            TextCustom(
                              TheText:
                                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry...",
                              TheTextSize: THelperFunctions.w(context, 0.03),
                              TheTextMaxLines: 20,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: ColorApp.tsecondaryColor,
                                ),
                                Icon(
                                  Icons.star,
                                  color: ColorApp.tsecondaryColor,
                                ),
                                Icon(
                                  Icons.star,
                                  color: ColorApp.tsecondaryColor,
                                ),
                                Icon(
                                  Icons.star,
                                  color: ColorApp.tsecondaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Divider + Row (en dehors du TabBarView)
            /*  const Divider(
                              color: ColorApp.tSombreColor,
                              thickness: 1,
                            ),
                           
                            const SizedBox(
                              height: 24,
                            ),  */
            // Pour un peu d'espace en bas
          ],
        ),
      ),
    );
  }
}

class CustomTabviewController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    //HomePageScreen(userFullName: "",),
    // FavoriteScreen(),
    // ChatListScreen(),
    //  ProfileScreen(),
  ];
}
