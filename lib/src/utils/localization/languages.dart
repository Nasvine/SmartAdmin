import 'package:get/get_navigation/src/root/internacionalization.dart';

class Languages extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      /* Authentification Error Language */

      /* Firebase Auth Exception */
      'auth.email_already_in_use':
          'The email address is already registered. Please use a different email.',
      'auth.invalid_email':
          'The email address provided is invalid. Please enter a valid email.',
      'auth.weak_password':
          'The password is too weak. Please choose a stronger password.',
      'auth.user_disabled':
          'This user account has been disabled. Please contact support.',
      'auth.user_not_found': 'Invalid login details. User not found.',
      'auth.wrong_password': 'Incorrect password. Please check and try again.',
      'auth.invalid_verification_code':
          'Invalid verification code. Please enter a valid code.',
      'auth.invalid_verification_id':
          'Invalid verification ID. Please request a new one.',
      'auth.quota_exceeded': 'Quota exceeded. Please try again later.',
      'auth.email_already_exists':
          'The email address already exists. Please use another one.',
      'auth.provider_already_linked':
          'This account is already linked with another provider.',
      'auth.requires_recent_login': 'Sensitive operation. Please log in again.',
      'auth.credential_already_in_use':
          'Credential already in use with another account.',
      'auth.user_mismatch': 'Credentials do not match the signed in user.',
      'auth.account_exists_with_different_credential':
          'Account exists with different sign-in credentials.',
      'auth.operation_not_allowed':
          'This operation is not allowed. Contact support.',
      'auth.invalid_action_code':
          'The action code is invalid. Please check and retry.',
      'auth.expired_action_code':
          'The action code has expired. Please request a new one.',
      'auth.missing_action_code':
          'The action code is missing. Please provide a valid one.',
      'auth.user_token_expired': 'User token expired. Please sign in again.',
      'auth.invalid_credential': 'Credential is malformed or expired.',
      'auth.user_token_revoked': 'User token revoked. Please sign in again.',
      'auth.invalid_message_payload': 'Email message payload is invalid.',
      'auth.invalid_sender': 'Email sender is invalid. Verify the email.',
      'auth.unknown': 'An unknown error occurred.',

      /* Firebase Exception */
      'firebase.unknown':
          'An unknown Firebase error occurred. Please try again.',
      'firebase.invalid_custom_token': 'The custom token format is incorrect.',
      'firebase.custom_token_mismatch':
          'The custom token corresponds to a different audience.',
      'firebase.user_disabled':
          'This user account has been disabled. Please contact support.',
      'firebase.user_not_found': 'Invalid login details. User not found.',
      'firebase.wrong_password':
          'Incorrect password. Please check your password and try again.',
      'firebase.weak_password':
          'The password is too weak. Please choose a stronger password.',
      'firebase.invalid_verification_code': 'Invalid verification code.',
      'firebase.invalid_verification_id': 'Invalid verification ID.',
      'firebase.quota_exceeded': 'Quota exceeded. Please try again later.',
      'firebase.email_already_exists': 'The email address already exists.',
      'firebase.provider_already_linked':
          'The account is already linked with another provider.',
      'firebase.requires_recent_login':
          'This operation requires recent authentication.',
      'firebase.credential_already_in_use':
          'The credential is already in use by another account.',
      'firebase.user_mismatch':
          'The credentials don’t match the signed in user.',
      'firebase.account_exists_with_different_credential':
          'An account already exists with a different credential.',
      'firebase.operation_not_allowed': 'This operation is not allowed.',
      'firebase.invalid_action_code': 'Invalid action code.',
      'firebase.expired_action_code': 'The action code has expired.',
      'firebase.missing_action_code': 'Missing action code.',
      'firebase.user_token_expired':
          'User token expired. Please sign in again.',
      'firebase.invalid_credential': 'Invalid credential.',
      'firebase.user_token_revoked': 'User token has been revoked.',
      'firebase.invalid_message_payload':
          'Invalid verification message payload.',
      'firebase.invalid_sender': 'Invalid email sender.',

      /* Format Exception */
      'format.invalid_email':
          'The email address format is invalid. Please enter a valid email.',
      'format.invalid_phone':
          'The provided phone number format is invalid. Please enter a valid number.',
      'format.invalid_date':
          'The date format is invalid. Please enter a valid date.',
      'format.invalid_url':
          'The URL format is invalid. Please enter a valid URL.',
      'format.unknown':
          'An unexpected format error occurred. Please check your input.',

      /* Platform Exception */
      'platform.invalid_login_credentials':
          'Invalid login credentials. Please double-check your information.',
      'platform.too_many_requests':
          'Too many requests. Please try again later.',
      'platform.invalid_argument':
          'Invalid argument provided to the authentication method.',
      'platform.invalid_password': 'Incorrect password. Please try again.',
      'platform.invalid_phone_number': 'The provided phone number is invalid.',
      'platform.operation_not_allowed':
          'The sign-in provider is disabled for your Firebase project.',
      'platform.session_cookie_expired':
          'The firebase session cookie has expired. Please sign in again.',
      'platform.uid_already_exists':
          'The provided user ID is already in use by another user.',
      'platform.sign_in_failed': 'Sign-in failed. Please try again.',
      'platform.network_request_failed':
          'Network request failed. Please check your internet connection.',
      'platform.internal_error': 'Internal error. Please try again later.',
      'platform.invalid_verification_code':
          'Invalid verification code. Please enter a valid code.',
      'platform.invalid_verification_id':
          'Invalid verification ID. Please request a new verification code.',
      'platform.quota_exceeded': 'Quota exceeded. Please try again later.',
      'platform.unexpected_error':
          'An unexpected platform error occurred. Please try again.',

      /* ------------------------------------------ */
      'email_hint': 'Enter email',
      // OnBoarding Texts
      "onBoardingTitle1": "Sell, Rent or Renovate a property.",
      "onBoardingTitle2":
          "Userry out real estate diagnostics of your accommodation.",
      "onBoardingTitle3": "Collaborate with real estate experts.",

      "onBoardingSubTitle1":
          "Provide information about your assets that will allow you to get in touch with diagnostic agents.",
      "onBoardingSubTitle2":
          "With Diag2France, get appointments with diagnostic agents located near you.",
      "onBoardingSubTitle3":
          "We assure you to have your DPE, asbestos diagnosis, lead diagnosis (CREP), Userrez area, habitable area, ERP (State of Risks and Pollution) compliant by a real estate diagnostician.",
      "tSkip": "Skip",

      // InternetExceptionsWidget Screen
      "tInternetExceptionstitle": "No Internet",
      "tInternetExceptions1":
          "We're unable tp show results. \n Please check your data\n connection.",
      "tInternetExceptions2": "Skip",
      "tRetry": "Retry",

      // GeneralExceptionsWidget Screen
      "tGeneralExceptionstitle": "No Internet",
      "tGeneralExceptions1":
          "We're unable to process your requests. \n Please try again.",
      "tGeneralExceptions2": "Skip",
      "tRetry": "Retry",

      "tLogin": "Login",
      "tRegister": "Register",
      "tVerifyEmail": "Verify Email",
      "tForgetPass": "Forgot Password",
      "tResetPassword": "Reset Password",
      "tSend": "Send",
      "tContinue": "Continue",
      "tModify": "Modify",
      "tHomeGreat": "Hello, welcome",
      "tEmailSent": "Email Sent",
      "tEmailLink": "Email link Sent to Reset your Password",
      "tWelcomeLogin": "Welcome Back",
      "tEmailSentMessage": "Please Check your inbox and verify your email.",
      "tSuccessCreateCompte": "Your account has been created! Verify email to continue.",
      

      // Welcome Screen
      "tWelcomeTitle": "Welcome to StayLog",
      "tWelcomeSubTitle":
          "To get started, please choose the following options:",

      // Login Text Screen
      "tLoginTitle": "Log in here!!!",
      "tLoginSubTitle": "Please enter your email and password...",
      "tRemerberMe": "Remember Me me",
      "tAlreadyHaveAnAccount": "Don't have an account?",

      "tEmail": "Email",
      "tPassword": "Password",
      "tForgetPassword": "Forgot Password?",
      "tSignWithGoogle": "Sign in with Google",
      "tSignWithPhone": "Sign in with Number",

      "tResendEmail": "Resend Verification",

      "tResetViaEmail": "Reset via Email",
      "tResetViaPhone": "Reset via Phone",

      //Register Text Screen
      "tRegisterTitle": "Who are you?",
      "tRegisterSubTitle": "Help us identify you!",
      "tAlreadyHave": "Do you have an account?",
      "tFirstName": "Last Name",
      "tLastName": "First Names",
      "tPhoneNo": "Phone Number",
      "tFullName": "Last & First Names",
      "tConfirmPassword": "Password Confirmation",
      "tAuthWithPhoneTitle": "Enter your number",

      // Success Text Screen
      "tAccountCreatedTitle": "Your account has been successfully created...",
      "tAccountCreatedSubTitle":
          "Welcome to StayLog! Explore our listings and find your next place to stay now.",

      // Forget Password
      "tForgetLongText":
          "Don't worry, sometimes people forget to do this, enter your email address and we'll send you a password reset link.",

      // Reset Password
      "tResetPasswordLogText":
          "Your account security is our priority! We've sent you a secure link to change your password and protect your account.",
      "tResetPasswordResendEmail": "Resend Email",

      // Profile Screen - Text
      "tProfile": "Profile",
      "tEditProfile": "Edit Profile",
      "tLogoutDialogHeading": "Logout",
      "tProfileHeading": "Nas Vine",
      "tProfileSubHeading": "super@gmail.com",

      // OPT Screen - Text
      "tOptTitle": "Code",
      "tOptSubTitle": "Verification",
      "tOptMessage": "Enter the verification code that was sent to you.",

      // Forget Password Options - Text
      "tSelection": "Make a selection!",
      "tSelectionText":
          "Select one of the options below to reset your password.",
      "//tSelection": "Make a selection!",

      // Menu
      "tMenu1": "Settings",
      "tMenu2": "Personal Information",
      "tLogout": "Logout",

      // Updated Profile Screen
      "tDelete": "Delete",
      "tJoined": "Joined",
      "tJoinedAt": "October 31 2022",

      // Text Home Screen
      "tCategory": "Categories",
      "tRecommended": "Recommended",
      "tSeeMore": "See more",
      "tAppartement": "Appartement",
      "tHousse": "Chambre",
      "tHotel": "Hôtel",
      "tVilla": "Villa",
      "tShop": "Boutique",

      // Error Message
      "tInvalide_Identifiants": "Invalid credentials or User no found.",

      // Select Person Page
      "tChoicePerson": "Choose the gender of the person.",
      "tMan": "Male",
      "tWoMan": "Female",

      // Create Mesure Page
      "tTakePicture": "Take a Photo",
      "tNameAndSurname": "Name and Surname",

      // Booking Page
      "tTitleBooking": "Booking",
      "tPhoneClient": "Your number ",
      "tChooseAllDates": "Choose your booking dates",
      "tSuccessReserve": "Reservation made successfully!!!",

      // Billing Page
      "tTitleBilling": "Billing",

      // Reviews Summary Page
      "tTitleReviewsSummary": "Reviews Summary",

      // Modal in Brand List
      "tAddBrand": "Add brand",
      "tUpdBrand": "Update brand",
      "tBrandName": "name of brand",
      "tBrandImage": "brand image",
      "tAddBtn": "Add",
      "tUpdBtn": "Update",
       "tMessageAddBrand": "Brand add successfully.",
      "tMessageUpdBrand": "Brand update successfully.",
      "tMessageDltBrand": "Brand delete successfully.",
    },
    'fr_FR': {
      /* Authentification Error Language */

      /* Firebase Auth Exception */
      'auth.email_already_in_use':
          'L\'adresse e-mail est déjà enregistrée. Veuillez en utiliser une autre.',
      'auth.invalid_email':
          'L\'adresse e-mail est invalide. Veuillez entrer une adresse valide.',
      'auth.weak_password':
          'Le mot de passe est trop faible. Choisissez un mot de passe plus fort.',
      'auth.user_disabled':
          'Ce compte utilisateur a été désactivé. Contactez le support.',
      'auth.user_not_found':
          'Détails de connexion invalides. Utilisateur non trouvé.',
      'auth.wrong_password': 'Mot de passe incorrect. Veuillez réessayer.',
      'auth.invalid_verification_code':
          'Code de vérification invalide. Veuillez réessayer.',
      'auth.invalid_verification_id':
          'ID de vérification invalide. Veuillez en demander un nouveau.',
      'auth.quota_exceeded': 'Quota dépassé. Réessayez plus tard.',
      'auth.email_already_exists':
          'L\'adresse e-mail existe déjà. Utilisez une autre adresse.',
      'auth.provider_already_linked':
          'Ce compte est déjà lié à un autre fournisseur.',
      'auth.requires_recent_login':
          'Opération sensible. Veuillez vous reconnecter.',
      'auth.credential_already_in_use':
          'Les identifiants sont déjà utilisés avec un autre compte.',
      'auth.user_mismatch':
          'Les identifiants ne correspondent pas à l\'utilisateur connecté.',
      'auth.account_exists_with_different_credential':
          'Un compte existe déjà avec des identifiants différents.',
      'auth.operation_not_allowed':
          'Cette opération n\'est pas autorisée. Contactez le support.',
      'auth.invalid_action_code':
          'Code d\'action invalide. Veuillez vérifier et réessayer.',
      'auth.expired_action_code':
          'Code d\'action expiré. Veuillez en demander un nouveau.',
      'auth.missing_action_code':
          'Code d\'action manquant. Veuillez en fournir un valide.',
      'auth.user_token_expired':
          'Jeton utilisateur expiré. Veuillez vous reconnecter.',
      'auth.invalid_credential': 'Identifiants invalides ou expirés.',
      'auth.user_token_revoked':
          'Jeton utilisateur révoqué. Veuillez vous reconnecter.',
      'auth.invalid_message_payload': 'Contenu du message invalide.',
      'auth.invalid_sender': 'Expéditeur invalide. Vérifiez l\'adresse e-mail.',
      'auth.unknown': 'Une erreur inconnue est survenue.',
      /* Firebase Exception */
      'firebase.unknown':
          'Une erreur Firebase inconnue s\'est produite. Veuillez réessayer.',
      'firebase.invalid_custom_token':
          'Le format du jeton personnalisé est incorrect.',
      'firebase.custom_token_mismatch':
          'Le jeton personnalisé correspond à un public différent.',
      'firebase.user_disabled':
          'Ce compte utilisateur a été désactivé. Contactez le support.',
      'firebase.user_not_found':
          'Identifiants invalides. Utilisateur introuvable.',
      'firebase.wrong_password': 'Mot de passe incorrect.',
      'firebase.weak_password': 'Le mot de passe est trop faible.',
      'firebase.invalid_verification_code': 'Code de vérification invalide.',
      'firebase.invalid_verification_id': 'ID de vérification invalide.',
      'firebase.quota_exceeded': 'Quota dépassé. Veuillez réessayer plus tard.',
      'firebase.email_already_exists': 'L\'adresse email existe déjà.',
      'firebase.provider_already_linked':
          'Le compte est déjà lié à un autre fournisseur.',
      'firebase.requires_recent_login':
          'Cette opération nécessite une authentification récente.',
      'firebase.credential_already_in_use':
          'Identifiants déjà utilisés par un autre compte.',
      'firebase.user_mismatch':
          'Les identifiants ne correspondent pas à l’utilisateur connecté.',
      'firebase.account_exists_with_different_credential':
          'Un compte existe avec un autre identifiant.',
      'firebase.operation_not_allowed': 'Cette opération n’est pas autorisée.',
      'firebase.invalid_action_code': 'Code d’action invalide.',
      'firebase.expired_action_code': 'Le code d’action a expiré.',
      'firebase.missing_action_code': 'Code d’action manquant.',
      'firebase.user_token_expired': 'Le jeton de l’utilisateur a expiré.',
      'firebase.invalid_credential': 'Identifiants invalides.',
      'firebase.user_token_revoked': 'Le jeton de l’utilisateur a été révoqué.',
      'firebase.invalid_message_payload':
          'Contenu du message de vérification invalide.',
      'firebase.invalid_sender': 'Expéditeur d\'email invalide.',

      /* Format Exception */
      'format.invalid_email':
          'Le format de l’adresse email est invalide. Veuillez saisir une adresse valide.',
      'format.invalid_phone':
          'Le format du numéro de téléphone est invalide. Veuillez saisir un numéro valide.',
      'format.invalid_date':
          'Le format de la date est invalide. Veuillez saisir une date valide.',
      'format.invalid_url':
          'Le format de l’URL est invalide. Veuillez saisir une URL valide.',
      'format.unknown':
          'Une erreur de format inattendue s’est produite. Veuillez vérifier votre saisie.',

      /* Platform Exception */
      'platform.invalid_login_credentials':
          'Identifiants de connexion invalides. Veuillez vérifier vos informations.',
      'platform.too_many_requests':
          'Trop de demandes. Veuillez réessayer plus tard.',
      'platform.invalid_argument':
          'Argument invalide fourni pour la méthode d\'authentification.',
      'platform.invalid_password':
          'Mot de passe incorrect. Veuillez réessayer.',
      'platform.invalid_phone_number':
          'Le numéro de téléphone fourni est invalide.',
      'platform.operation_not_allowed':
          'Le fournisseur de connexion est désactivé pour votre projet Firebase.',
      'platform.session_cookie_expired':
          'Le cookie de session Firebase a expiré. Veuillez vous reconnecter.',
      'platform.uid_already_exists':
          'L\'ID utilisateur fourni est déjà utilisé par un autre utilisateur.',
      'platform.sign_in_failed': 'Échec de la connexion. Veuillez réessayer.',
      'platform.network_request_failed':
          'Échec de la requête réseau. Veuillez vérifier votre connexion internet.',
      'platform.internal_error':
          'Erreur interne. Veuillez réessayer plus tard.',
      'platform.invalid_verification_code':
          'Code de vérification invalide. Veuillez entrer un code valide.',
      'platform.invalid_verification_id':
          'ID de vérification invalide. Veuillez demander un nouveau code.',
      'platform.quota_exceeded': 'Quota dépassé. Veuillez réessayer plus tard.',
      'platform.unexpected_error':
          'Une erreur inattendue s\'est produite. Veuillez réessayer.',

      /* ----------------------------- */
      'email_hint': 'Entrer votre email',
      //Generic Text
      "tLogin": "Connexion",
      "tRegister": "Inscription",
      "tVerifyEmail": "Verification de l'Email",
      "tForgetPass": "Mot de Passe oublié",
      "tResetPassword": "Réinitialisation du mot de passe",
      "tSend": "Envoyer",
      "tContinue": "Continuer",
      "tModify": "Modifier",
      "tHomeGreat": "Hello, bienvenue",
      "tEmailSent": "Email Envoyé",
      "tEmailLink": "Lien par e-mail envoyé pour réinitialiser votre mot de passe",
      "tWelcomeLogin": "Bienvenue sur SmartService ! 👋",
      "tWelcomeLogin1": "Content de vous revoir",
      "tWelcomeLogin2": "Connectez-vous pour continuer.",

      //Welcome Screen
      "tWelcomeTitle": "Bienvenue sur StayLog",
      "tWelcomeSubTitle":
          "Pour commencer, veuillez choisir les options suivants:",

      // Login Text Screen
      "tLoginTitle": "Connectez-vous ici ! ! !",
      "tLoginSubTitle": "Veuillez entrer votre email et mot de passe ...",
      "tRemerberMe": "Se souvenir de moi",
      "tAlreadyHaveAnAccount": "Vous n'avez pas un compte ?",

      "tEmail": "Email",
      "tPassword": "Mot de Passe",
      "tForgetPassword": "Mot de Passe oublie ?",
      "tSignWithGoogle": "Connexion avec Google",
      "tSignWithPhone": "Connexion avec Numéro",

      "tResendEmail": "Renvoyez la vérification",

      "tResetViaEmail": "Réinitialiser via E-mail",
      "tResetViaPhone": "Réinitialiser via Phone",

      //Register Text Screen
      "tRegisterTitle": "Qui êtes-vous ? 🤔",
      "tRegisterSubTitle": "Aidez-nous à vous identifier!",
      "tAlreadyHave": "Vous avez un compte ?",
      "tFirstName": "Nom",
      "tLastName": "Prénoms",
      "tPhoneNo": "Numéro de Téléphone",
      "tFullName": "Nom & Prénoms",
      "tConfirmPassword": "Confirmation du mot de Passe",
      "tAuthWithPhoneTitle": "Entrez votre numéro",
      "tChangePassword": "Modifier le mot de Passe",
      "tShopName": "Nom de l'atélier",
      "tShopAdress": "Adresse de l'atélier",
      "tUserAdress": "Votre Adresse",

      // Success Text Screen
      "tAccountCreatedTitle": "Votre compte a été créé avec succès...",
      "tAccountCreatedSubTitle":
          "Bienvenue sur StayLog! Explorez nos annonces et trouvez votre prochain logement dès maintenant.",

      // Forget Password
      "tForgetLongText":
          "Ne vous inquiétez pas, parfois les gens peuvent oublier de le faire, entrez votre adresse e-mail et nous vous enverrons un lien de réinitialisation du mot de passe.",

      // Reset Password
      "tResetPasswordLogText":
          "La sécurité de votre compte est notre priorité ! Nous vous avons envoyé un lien sécurisé pour changer votre mot de passe et protéger votre compte.",
      "tResetPasswordResendEmail": "Renvoyer l'Email",

      // Profile Screen - Text
      "tProfile": "Profile",
      "tEditProfile": "Editer Profile",
      "tLogoutDialogHeading": "Déconnexion",
      "tProfileHeading": "Nas Vine",
      "tProfileSubHeading": "super@gmail.com",


      // Crud Users

       // Crud User
      "tAddUser": "Ajout un utilisateur",
      "tUpdUser": "Modification des informations",
      "tUserName": "Nom & Prénoms",
      "tUserEmail": "Email de l'utilisateur",
      "tUserAdresse": "Adresse de l'utilisateur",
      "tUserPhone": "Numéro de l'utilisateur",
      "tUserRole": "Selectionnez le rôle",
      "tUserRoleText": "rôle",
      "tUserImage": "Photo de l'utilisateur",
      "tUserImageText": "Télécharger l'image",
      "tAddBtn": "Ajouter",
      "tUpdBtn": "Modifier",
      "tSearchUser": "Rechercher un utilisateur",
      "tSearchDeliver": "Rechercher un livreur",

      "tUserBrand": "Marque de la voiture",
      "tUserLists": "Liste des utilisateurs",
      "tDeliverLists": "Liste des Livreurs",
      "tUserDescription": "Description de la voiture",
      "tMessageAddUser": "Utilisateur ajouté(e) avec succès.",
      "tMessageUpdUser": "Utilisateur modifié(e) avec succès.",
      "tMessageDltUser": "Utilisateur supprimé(e) avec succès.",
      "ImpossibleAction": "Action Impossible",
      "ImpossibleActionMessage": "Vous n'avez pas ajouté cette voiture.",
      "ImpossibleActionDelete": "Action Impossible",
      "ImpossibleActionMessageDelete": "Vous n'avez pas ajouté cette voiture.",
      "ImpossibleActionAdd": "Action Impossible",
      "ImpossibleActionMessageAdd": "Vous devez vérifier votre compte.",
      "DeleteUserMessage": "Voulez-vous vraiment supprimer l'utilisateur ?",
      "tClientBannerGalerieImage": "Bannière des Clients",
      "tClientBannerGalerieImageText": "Télécharger des images",

      // OPT Screen - Text
      "tOptTitle": "Code",
      "tOptSubTitle": "Verification",
      "tOptMessage": "Entrer le code de vérification qui vous a été envoyé.",

      // Forget Password Options - Text
      "tSelection": "Faire une selection !",
      "tSelectionText":
          "Sélectionnez l'une des options ci-dessous pour réinitialiser votre mot de passe.",
      "//tSelection": "Faire une selection !",

      // Menu
      "tMenu1": "Paramètre",
      "tMenu2": "Information Personnelle",
      "tLogout": "Logout",

      // Updated Profile Screen
      "tDelete": "Delete",
      "tJoined": "Joined",
      "tJoinedAt": "31 Octobre 2022",

      // Text Home Screen
      "tCategorie": "Catégories",
      "tRecommanded": "Recommendés",
      "tSeeMore": "Voir plus",
      "tAppartement": "Appartement",
      "tHousse": "Chambre",
      "tHotel": "Hôtel",
      "tVilla": "Villa",
      "tShop": "Boutique",

      // OnBoarding Texts
      "onBoardingTitle1": "Vendre, Louer ou Rénover un bien.",
      "onBoardingTitle2":
          "Effectuer les diagnostics immobiliers de vos logements.",
      "onBoardingTitle3": "Collaborer avec des experts immobiliers",

      "onBoardingSubTitle1":
          "Fournissez des informations sur vos biens vous permettant d'entrée en relation avec des agents de diagnostics.",
      "onBoardingSubTitle2":
          "Avec Diag2France, obtenez des rendez-vous avec des agents de diagnostics situés près de vous.",
      "onBoardingSubTitle3":
          "Nous vous assurons d'avoir votre DPE, diagnostic amiante, surface habitable, ERP (Etat des Risques et Pollution) conformes par un diagnostiqueur immobilier.",
      "tSkip": "Passer",

      "tInternetExceptionstitle": "Pas d'Internet",
      "tInternetExceptions1":
          "Nous ne pouvons pas afficher les résultats. \n Veuillez vérifier votre connexion de données\n.",
      "tInternetExceptions2": "Skip",
      "tRetry": "Essayer",

      // GeneralExceptionsWidget Screen
      "tGeneralExceptionstitle": "Erreur de traitement",
      "tGeneralExceptions1":
          "Nous ne sommes pas en mesure de traiter vos demandes. \n Veuillez réessayer.",
      "tGeneralExceptions2": "Skip",
      "tRetry": "Retry",

      // Error Message
      "tInvalide_Identifiants":
          "Identifiants Incorrects ou Compte innexistant.",


      // Billing Page
      "tTitleBilling": "Facturation",

      // Reviews Summary Page
      "tTitleReviewsSummary": "Reviews Summary",

     // Modal in Brand List
      "tAddBrand": "Ajouter une marque",
      "tBrandName": "Nom de la marque",
      "tBrandImage": "Télécharger l'image de la marque",
      "tUpdBrand": "Modifier une marque",
      "tAddBtn": "Ajouter",
      "tUpdBtn": "Modifier",
      "tMessageAddBrand": "Marque ajouté(e) avec succès.",
      "tMessageUpdBrand": "Marque ajouté(e) avec succès.",
      "tMessageDltBrand": "Marque supprimé(e) avec succès.",
      "DeleteBrandMessage": "Voulez-vous vraiment supprimer cette marque ?",


      // Verification
      "companyName": "Nom de l'entreprise",
      "companyOwnerName": "Nom du propriétaire",
      "companyIFUNumber": "Numéro IFU",
      "companyAdresse": "Adresse de l'entreprise",
      "companyNumber": "Numéro de l'entreprise",
      "companyRegisteSell": "Registre de commerce de l'entreprise",
      "instructionCompanyAdresse": "Assurz-vous d'être dans votre l'entreprise.",
      // Profile

      "tPolicy" : "Politique de Confidentialité",
      "tAbout" : "A propos de SmartService",
      "tGiveAvis" : "Noter l'application",

      // Form order

      "tTitle" : "Nouvelle commande",
      "tStartAdresse" : "Adresse de départ",
      "tSlectStartAdresse" : "Selectionner l'adresse de départ",
      "tEndAdresse" : "Adresse de destination",
      "tSlectEndAdresse" : "Selectionner l'adresse de destination",
      "tPackageType" : "Type de colis",
      "tMessageToDeliver" : "Message au livreur",
      "tNoLocation" : "Aucun emplacement choisi.",
      "tMessageCancelText" : "Motif",
      "tMessageCancel" : "Entrer le motif.",
      "tMessageAddOrders": "Course ajouté(e) avec succès.",
      "tMessageCancelOrders": "Course annulé(e) avec succès.",
      "tMessageUpdOrders": "Course modifié(e) avec succès.",


   
    },
    'fo_FO': {
      'email_hint': 'Entrer votre email',
      //Generic Text
      "tLogin": "Connexion",
      "tRegister": "Inscription",
      "tVerifyEmail": "Verification de l'Email",
      "tForgetPass": "Mot de Passe oublié",
      "tResetPassword": "Réinitialisation du mot de passe",
      "tSend": "Envoyer",
      "tContinue": "Continuer",
      "tModify": "Modifier",
      "tHomeGreat": "Hello, bienvenue",
      "tEmailSent": "Email Envoyé",
      "tEmailSentMessage": "Veuillez vérifier votre boîte de réception et vérifier votre e-mail.",
      "tSuccessCreateCompte": "Votre compte a bien été créé ! Veuillez vérifier votre adresse e-mail pour continuer.",
      "tEmailLink": "Lien par e-mail envoyé pour réinitialiser votre mot de passe",
      

      //Welcome Screen
      "tWelcomeTitle": "Bienvenue sur StayLog",
      "tWelcomeSubTitle":
          "Pour commencer, veuillez choisir les options suivants:",

      // Login Text Screen
      "tLoginTitle": "Connectez-vous ici ! ! !",
      "tLoginSubTitle": "Veuillez entrer votre email et mot de passe ...",
      "tRemerberMe": "Se souvenir de moi",
      "tAlreadyHaveAnAccount": "Vous n'avez pas un compte ?",

      "tEmail": "Email",
      "tPassword": "Mot de Passe",
      "tForgetPassword": "Mot de Passe oublie ?",
      "tSignWithGoogle": "Connexion avec Google",
      "tSignWithPhone": "Connexion avec Numéro",

      "tResendEmail": "Renvoyez la vérification",

      "tResetViaEmail": "Réinitialiser via E-mail",
      "tResetViaPhone": "Réinitialiser via Phone",

      //Register Text Screen
      "tRegisterTitle": "Qui êtes-vous ?",
      "tRegisterSubTitle": "Aidez-nous à vous identifier!",
      "tAlreadyHave": "Vous avez un compte ?",
      "tFirstName": "Nom",
      "tLastName": "Prénoms",
      "tPhoneNo": "Numéro de Téléphone",
      "tFullName": "Nom & Prénoms",
      "tConfirmPassword": "Confirmation du mot de Passe",
      "tAuthWithPhoneTitle": "Entrez votre numéro",

      // Success Text Screen
      "tAccountCreatedTitle": "Votre compte a été créé avec succès...",
      "tAccountCreatedSubTitle":
          "Bienvenue sur StayLog! Explorez nos annonces et trouvez votre prochain logement dès maintenant.",

      // Forget Password
      "tForgetLongText":
          "Ne vous inquiétez pas, parfois les gens peuvent oublier de le faire, entrez votre adresse e-mail et nous vous enverrons un lien de réinitialisation du mot de passe.",

      // Reset Password
      "tResetPasswordLogText":
          "La sécurité de votre compte est notre priorité ! Nous vous avons envoyé un lien sécurisé pour changer votre mot de passe et protéger votre compte.",
      "tResetPasswordResendEmail": "Renvoyer l'Email",

      // Profile Screen - Text
      "tProfile": "Profile",
      "tEditProfile": "Edit Profile",
      "tLogoutDialogHeading": "Déconnexion",
      "tProfileHeading": "Nas Vine",
      "tProfileSubHeading": "super@gmail.com",

      // OPT Screen - Text
      "tOptTitle": "Code",
      "tOptSubTitle": "Verification",
      "tOptMessage": "Entrer le code de vérification qui vous a été envoyé.",

      // Forget Password Options - Text
      "tSelection": "Faire une selection !",
      "tSelectionText":
          "Sélectionnez l'une des options ci-dessous pour réinitialiser votre mot de passe.",
      "//tSelection": "Faire une selection !",

      // Menu
      "tMenu1": "Paramètre",
      "tMenu2": "Information Personnelle",
      "tLogout": "Logout",

      // Updated Profile Screen
      "tDelete": "Delete",
      "tJoined": "Joined",
      "tJoinedAt": "31 Octobre 2022",

      // Text Home Screen
      "tCategorie": "Catégories",
      "tRecommanded": "Recommendés",
      "tSeeMore": "Voir plus",
      "tAppartement": "Appartement",
      "tHousse": "Chambre",
      "tHotel": "Hôtel",
      "tVilla": "Villa",
      "tShop": "Boutique",

      // OnBoarding Texts
      "onBoardingTitle1": "Vendre, Louer ou Rénover un bien.",
      "onBoardingTitle2":
          "Effectuer les diagnostics immobiliers de vos logements.",
      "onBoardingTitle3": "Collaborer avec des experts immobiliers",

      "onBoardingSubTitle1":
          "Fournissez des informations sur vos biens vous permettant d'entrée en relation avec des agents de diagnostics.",
      "onBoardingSubTitle2":
          "Avec Diag2France, obtenez des rendez-vous avec des agents de diagnostics situés près de vous.",
      "onBoardingSubTitle3":
          "Nous vous assurons d'avoir votre DPE, diagnostic amiante, surface habitable, ERP (Etat des Risques et Pollution) conformes par un diagnostiqueur immobilier.",
      "tSkip": "Passer",

      "tInternetExceptionstitle": "Pas d'Internet",
      "tInternetExceptions1":
          "Nous ne pouvons pas afficher les résultats. \n Veuillez vérifier votre connexion de données\n.",
      "tInternetExceptions2": "Skip",
      "tRetry": "Essayer",

      // GeneralExceptionsWidget Screen
      "tGeneralExceptionstitle": "Erreur de traitement",
      "tGeneralExceptions1":
          "Nous ne sommes pas en mesure de traiter vos demandes. \n Veuillez réessayer.",
      "tGeneralExceptions2": "Skip",
      "tRetry": "Retry",

      // Error Message
      "tInvalide_Identifiants":
          "Identifiants Incorrects ou Compte innexistant.",

      // Select Person Page
      "tChoicePerson": "Sɔ́ sunnu alǒ nyɔnu e mɛ ɔ nyí é.",
      "tMan": "Sunnu",
      "tWoMan": "Nyɔnu",
    },
  };
}
