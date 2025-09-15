import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/screens/tabs.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class AboutOwnerPage extends StatelessWidget {
  const AboutOwnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos de CarRentalOwner'),
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => TabsScreen(initialIndex: 3));
          },
          icon: Icon(
            LineAwesomeIcons.angle_left_solid,
            color: isDark ? ColorApp.tWhiteColor : ColorApp.tBlackColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'CarRentalOwner',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: ColorApp.tsecondaryColor,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'CarRentalOwner est l’application mobile dédiée aux propriétaires de véhicules souhaitant gérer leur activité de location. Elle permet de publier des voitures, fixer les prix par jour, discuter avec les clients, gérer les marques, accepter les réservations et confirmer les paiements via MoMo.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'Fonctionnalités clés :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            bulletPoint('Inscription par email, mot de passe ou Google'),
            bulletPoint('Ajout de voitures avec prix journalier'),
            bulletPoint('Création et gestion de marques'),
            bulletPoint('Chat intégré avec les clients'),
            bulletPoint('Réception des commandes'),
            bulletPoint('Confirmation du paiement MoMo via KKiaPay'),
            bulletPoint('Notifications en temps réel'),
            const SizedBox(height: 20),
            const Text(
              'Une contribution pour un service durable 🔧',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorApp.tsecondaryColor,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Certaines fonctionnalités avancées peuvent être soumises à une contribution symbolique dans le futur. Cette contribution permettra de maintenir un service fiable, sécurisé et en constante amélioration.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: ColorApp.tsecondaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pourquoi une contribution ? 💡',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: ColorApp.tsecondaryColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Cela nous permet de :',
                    style: TextStyle(fontSize: 15, height: 1.6),
                  ),
                  SizedBox(height: 8),
                  Text('• Garantir la disponibilité du service'),
                  Text('• Sécuriser les données de vos véhicules et clients'),
                  Text('• Intégrer des outils avancés de gestion'),
                  Text('• Offrir un support rapide en cas de souci'),
                  Text('• Déployer des mises à jour régulières'),
                  SizedBox(height: 10),
                  Text(
                    'Merci pour votre confiance et votre collaboration 🤝',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: ColorApp.tsecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Développé par :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            infoLine('Nom', 'NASSARA Kévine'),
            infoLine('Métier', 'Développeur mobile Flutter (Android & iOS)'),
            infoLine('Pays', 'Bénin'),
            const SizedBox(height: 20),
            const Text(
              'Technologies utilisées :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            bulletPoint('Flutter'),
            bulletPoint('Dart'),
            bulletPoint('Firebase (Auth, Firestore, Cloud Functions)'),
            bulletPoint('Kkiapay (paiement Mobile Money)'),
            const SizedBox(height: 20),
            const Text(
              'Version de l\'application :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Version 1.0.0', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'Merci d\'utiliser CarRentalOwner ❤️',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  color: ColorApp.tsecondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget bulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("• ", style: TextStyle(fontSize: 18)),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ],
    );
  }

  static Widget infoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
