import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/constants/texts.dart';
import 'package:smart_admin/src/screens/auth/login_screen.dart';
import 'package:smart_admin/src/screens/auth/register_sreen.dart';
import 'package:smart_admin/src/utils/texts/button_custom.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arrière-plan (image)
          Positioned.fill(
            child: Image.asset("assets/Image1.jpg", fit: BoxFit.cover),
          ),

          // Couleur de superposition si besoin (optionnel)
          Positioned.fill(
            child: Container(
              /* color: Colors.black.withOpacity(
                0.2,
              ), */ // Pour rendre le texte plus lisible
            ),
          ),

          // Contenu au-dessus de l'image
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /* const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Démarrer l’aventure',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Transformez vos voitures en source de revenus. Gagnez sans stress, en quelques clics.',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30), */
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ButtonCustom(
                        text: "Commencer",
                        textSize: 15,
                        buttonBackgroundColor: ColorApp.tsecondaryColor,
                        onPressed: () => Get.to(() => RegisterScreen()),
                      ),
                    ),
                  /*   const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextCustom(
                          TheText: TextApp.tAlreadyHave,
                          TheTextSize: 12,
                          TheTextColor: Colors.white,
                        ),
                        TextButton(
                          onPressed: () => Get.to(() => LoginScreen()),
                          child: TextCustom(
                            TheText: TextApp.tLogin,
                            TheTextSize: 14,
                            TheTextColor: ColorApp.tsecondaryColor,
                            TheTextFontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(), */
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
