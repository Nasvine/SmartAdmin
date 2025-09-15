import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/screens/tabs.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';

class PrivacyPolicyOwnerPage extends StatelessWidget {
  const PrivacyPolicyOwnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Politique de Confidentialité'),
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
          children: const [
            SectionTitle('Dernière mise à jour : 02 août 2025'),
            SizedBox(height: 20),

            SectionTitle('1. Introduction'),
            SectionContent(
              'Bienvenue dans l\'application CarRentalOwner, conçue pour les propriétaires de véhicules souhaitant gérer leur activité de location. '
              'Cette politique de confidentialité explique comment nous collectons, utilisons, stockons et protégeons vos données personnelles.',
            ),

            SectionTitle('2. Données collectées'),
            SectionSubTitle('a) Propriétaires de véhicules :'),
            BulletPoint('Nom et prénom'),
            BulletPoint('Adresse e-mail'),
            BulletPoint('Numéro de téléphone'),
            BulletPoint('Mot de passe (crypté)'),
            BulletPoint('Connexion via email/mot de passe ou Google'),
            BulletPoint(
              'Informations sur les véhicules (modèle, marque, prix)',
            ),
            BulletPoint('Historique des réservations'),
            BulletPoint('Messages échangés avec les clients'),

            SectionTitle('3. Utilisation des données'),
            SectionContent(
              'Vos données sont utilisées pour :\n\n'
              '- Créer et gérer votre compte propriétaire\n'
              '- Ajouter, modifier ou supprimer vos véhicules\n'
              '- Communiquer avec les clients\n'
              '- Gérer les réservations reçues\n'
              '- Confirmer les paiements via Kkiapay\n'
              '- Envoyer des notifications (réservations, paiements, messages)\n'
              '- Garantir la sécurité et la fiabilité de l\'application',
            ),

            SectionTitle('4. Paiement'),
            SectionContent(
              'Les paiements sont assurés par notre partenaire Kkiapay, une solution sécurisée de Mobile Money. '
              'CarRentalOwner ne stocke aucune information bancaire : toutes les transactions sont sécurisées directement par Kkiapay.',
            ),

            SectionTitle('5. Partage des données'),
            SectionContent(
              'Nous ne partageons vos informations personnelles que dans les cas suivants :\n\n'
              '- Lorsqu\'un client réserve un véhicule, certaines informations (nom, téléphone) sont transmises à ce client\n'
              '- En cas d\'obligation légale ou à la demande d\'une autorité compétente\n',
            ),

            SectionTitle('6. Sécurité des données'),
            SectionContent(
              'Toutes vos données sont stockées sur Firebase avec les garanties suivantes :\n\n'
              '- Authentification via Firebase Auth\n'
              '- Données enregistrées dans Firestore avec des règles de sécurité strictes\n\n'
              'Nous nous engageons à mettre en œuvre des pratiques de sécurité avancées pour protéger vos informations.',
            ),

            SectionTitle('7. Vos droits'),
            SectionContent(
              'En tant qu\'utilisateur, vous avez le droit de :\n\n'
              '- Accéder à vos données personnelles\n'
              '- Corriger toute information inexacte\n'
              '- Supprimer votre compte à tout moment\n\n'
              'Pour exercer ces droits, contactez : nassara.kevine@gmail.com',
            ),

            SectionTitle('8. Durée de conservation'),
            SectionContent(
              'Vos données sont conservées aussi longtemps que votre compte est actif. En cas de suppression, vos données seront supprimées dans un délai raisonnable.',
            ),

            SectionTitle('9. Consentement'),
            SectionContent(
              'En utilisant CarRentalOwner, vous acceptez cette politique de confidentialité. '
              'Si vous n’êtes pas en accord, veuillez ne pas utiliser l\'application.',
            ),

            SectionTitle('10. Modifications'),
            SectionContent(
              'Cette politique peut évoluer. Toute modification significative sera affichée dans l\'application.',
            ),

            SectionTitle('11. Contact'),
            SectionContent(
              'Pour toute question ou préoccupation concernant la confidentialité :',
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email : vinenassara@gmail.com',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: 4),
                Text(
                  'Téléphone : +229 01 91 003 606',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),

            SizedBox(height: 30),
            Center(
              child: Text(
                'Merci d\'utiliser CarRentalOwner 🚗',
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
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class SectionSubTitle extends StatelessWidget {
  final String text;
  const SectionSubTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class SectionContent extends StatelessWidget {
  final String text;
  const SectionContent(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 15),
      child: Text(text, style: const TextStyle(fontSize: 16, height: 1.5)),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
