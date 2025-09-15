import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/models/auth/notification_model.dart';
import 'package:smart_admin/src/repository/authentification_repository.dart';
import 'package:smart_admin/src/screens/chat/chat_list_screen.dart';
import 'package:smart_admin/src/screens/drawer/drawer_listTile.dart';
import 'package:smart_admin/src/screens/home_page/home.dart';
import 'package:smart_admin/src/screens/home_page/profile.dart';
import 'package:smart_admin/src/screens/home_page/settings_screen.dart';
import 'package:smart_admin/src/screens/notification.dart';
import 'package:smart_admin/src/screens/orders/orders.dart';
import 'package:smart_admin/src/screens/users/deliver_list.dart';
import 'package:smart_admin/src/screens/users/user_list.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';
import 'package:smart_admin/src/utils/widget_theme/circle_icon_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'drawer/drawer_header.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final controller = Get.put(TabsScreenController());

  Stream<int> getNotificationTotal(String userId) {
    return FirebaseFirestore.instance
        .collection('notifications')
        .where(
          'receiverRef',
          isEqualTo: FirebaseFirestore.instance.collection('users').doc(userId),
        )
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return 0;

          return snapshot.docs.length;
        });
  }

  @override
  Widget build(BuildContext context) {
    controller._selectedIndex.value = widget.initialIndex;
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(
              "Voulez-vous vraiment quitter SmartService ?",
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("Annuler"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Quitter"),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: StreamBuilder(
                stream: getNotificationTotal(
                  FirebaseAuth.instance.currentUser!.uid,
                ),
                builder: (context, asyncSnapshot) {
                  if (!asyncSnapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Badge.count(
                    count: asyncSnapshot.data!,
                    child: CircleIconCustom(
                      headerIcon1: Icons.notifications,
                      isDark: isDark,
                      onPressed: () async {
                        final notifications = await FirebaseFirestore.instance
                            .collection('notifications')
                            .where(
                              'receiverRef',
                              isEqualTo: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid),
                            )
                            .get();

                        for (final doc in notifications.docs) {
                          final data = NotificationModel.fromSnapshot(doc);
                          if (data.isRead == false) {
                            await FirebaseFirestore.instance
                                .collection('notifications')
                                .doc(doc.id)
                                .update({'isRead': true});
                          }
                        }
                        Get.to(() => NotificationScreen());
                      },
                    ),
                  );
                },
              ),
            ),
          ],
          title: Obx(() {
            final index = controller._selectedIndex.value;
            String title;

            switch (index) {
              case 0:
                title = 'Tableau de Bord';
                break;
              case 1:
                title = 'Liste des courses';
                break;
              case 2:
                title = 'Listes de mes discussions';
                break;
              case 3:
                title = 'Mon Profile';
                break;
              default:
                title = 'Rental App';
            }

            return Text(title);
          }),
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: Obx(() {
          if (controller.user.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return controller.screens[controller._selectedIndex.value];
        }),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: THelperFunctions.isDarkMode(context)
                ? ColorApp.tBlackColor
                : ColorApp.tWhiteColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Theme.of(context).shadowColor.withOpacity(0.1),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 8,
              ),
              child: GNav(
                rippleColor: Theme.of(context).hoverColor,
                hoverColor: Theme.of(context).hoverColor,
                gap: 8,
                activeColor: Theme.of(context).colorScheme.onPrimary,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Theme.of(context).colorScheme.primary,
                color: Theme.of(context).iconTheme.color,
                tabs: const [
                  GButton(icon: LineIcons.home, text: 'Home'),
                  GButton(icon: Icons.list_sharp, text: 'Courses'),
                  GButton(icon: LineIcons.comments, text: 'Chats'),
                  GButton(icon: LineIcons.user, text: 'Profile'),
                ],
                selectedIndex: controller._selectedIndex.value,
                onTabChange: (index) {
                  controller._selectedIndex.value = index;
                },
              ),
            ),
          ),
        ),

        drawer: Obx(() {
          if (controller.user.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Drawer(
            child: ListView(
              children: [
                DrawerHeaderCustom(
                  displayName: controller.user['fullName'],
                  email: "${controller.user['email']}",
                  photo: controller.user['profilePicture'],
                ),
                DrawerListTile(
                  title: "Discussions",
                  titleColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  icon: LineIcons.commentAlt,
                  iconColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  onTap: () => Get.offAll(() => TabsScreen(initialIndex: 2)),
                ),
                DrawerListTile(
                  title: "Commandes",
                  titleColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  icon: Icons.list_sharp,
                  iconColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  onTap: () => Get.offAll(() => TabsScreen(initialIndex: 1)),
                ),
                DrawerListTile(
                  title: "Transactions",
                  titleColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  icon: Icons.import_export,
                  iconColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  onTap: () => Get.offAll(() => TabsScreen(initialIndex: 1)),
                ),
                DrawerListTile(
                  title: "Livreurs",
                  titleColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  icon: Icons.delivery_dining_outlined,
                  iconColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  onTap: () => Get.offAll(() => DeliverListScreen()),
                ),
                DrawerListTile(
                  title: "Utilisateurs",
                  titleColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  icon: LineIcons.user,
                  iconColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  onTap: () => Get.offAll(() => UserListScreen()),
                ),
                Divider(
                  height: 18,
                  color: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                ),
                DrawerListTile(
                  title: "Notifications",
                  titleColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  icon: Icons.notifications_active,
                  iconColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  onTap: () => Get.offAll(() => NotificationScreen()),
                ),
                DrawerListTile(
                  title: "Paramètres",
                  titleColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  icon: Icons.settings,
                  iconColor: THelperFunctions.isDarkMode(context)
                      ? ColorApp.tWhiteColor
                      : ColorApp.tBlackColor,
                  onTap: () => Get.to(() => SettingsScreen()),
                ),
                DrawerListTile(
                  title: "Déconnexion",
                  titleColor: Colors.red,
                  icon: Icons.logout_outlined,
                  iconColor: Colors.red,
                  onTap: () => AuthentificationRepository.instance.logout(),
                ),
              ],
            ),
          );
        }),
      ),
    );

    /*  return  */
  }
}

class TabsScreenController extends GetxController {
  static TabsScreenController get to => Get.find();

  final _selectedIndex = 0.obs;
  final userConnectName = ''.obs;
  final user = <String, dynamic>{}.obs;
  final auth = FirebaseAuth.instance.currentUser!;
  RxBool accountVerified = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
  }

  void _getUserInfo() async {
    final data = await AuthentificationRepository.instance.getUserInfo(
      auth.uid,
    );
    if (data.isNotEmpty) {
      user.value = data;
      userConnectName.value = data['fullName'];
      List<String> parts = userConnectName.value.trim().split(" ");

      // Récupérer le prénom (le deuxième mot s’il existe)
      userConnectName.value = parts.length >= 2 ? parts[1] : '';
    } else {
      print('No data');
    }
  }

  List<Widget> get screens => [
    HomeScreen(
      userFullName: user['fullName'],
      userEmail: user['email'],
    ),
    OrdersScreen(),
    ChatListScreen(),
    ProfileScreen(
      userFullName: user['fullName'],
      userEmail: user['email'],
    ),
  ];
}
