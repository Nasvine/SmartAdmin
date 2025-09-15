
import 'package:smart_admin/src/repository/authentification_repository.dart';
import 'package:smart_admin/src/screens/welcome/welcome.dart';
import 'package:smart_admin/src/utils/localization/languages.dart';
import 'package:smart_admin/src/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'package:smart_admin/notification_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
   final WidgetsBinding widgetsBinding =  WidgetsFlutterBinding.ensureInitialized();

  /// GetX Local Storage

  /// Await Splash until other items Load
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// Initialize Firebase & Authentication Repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) => Get.put(AuthentificationRepository()));
  await GetStorage.init();
  await dotenv.load(fileName: '.env');
  final notificationService = NotificationServices();
  await notificationService.initFCM();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Admin',
      debugShowCheckedModeBanner: false,
      /*  theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorApp.tWhiteColor),
      ), */
      // themeMode: ThemeMode.dark,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: const WelcomeScreen(),
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      translations: Languages(),
      locale: Locale('fr', 'FR'),
      fallbackLocale: Locale('fr', 'FR'),
    );
  }
}
