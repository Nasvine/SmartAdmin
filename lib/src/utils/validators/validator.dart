class TValidator {
  /// Empty Text Validation
  static String? validationEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName est réquis';
    }
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "l'Email est réquis.";
    }

    final emailRegExp = RegExp(r'^[\w\.-]+@+[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Adresse Email invalid.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "le mot de passe est réquis.";
    }

    // Check for minimum password lenght
    if (value.length < 8) {
      return "le mot de passe doit contenir au moins 08 caractères.";
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return "Le mot de passe doit contenir au moins une lettre majuscule.";
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return "Le mot de passe doit contenir au moins un chiffre.";
    }

    // Check for specials characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Le mot de passe doit contenir au moins un caractère spécial.";
    }

    return null;
  }

  static String? validationPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de Téléphone est réquis';
    }

    final phoneRegExp = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    if (!phoneRegExp.hasMatch(value)) {
      return "Format de numéro invalide (10 chiffres requis)";
    }

    return null;
  }

  static String? validationCarYear(String? value) {
    if (value == null || value.isEmpty) {
      return "L'année est requise";
    }

    final yearRegExp = RegExp(r'^\d{4}$');
    if (!yearRegExp.hasMatch(value)) {
      return "Année invalide (4 chiffres requis)";
    }

    final int year = int.parse(value);
    final int currentYear = DateTime.now().year;

    if (year > currentYear) {
      return "L'année ne peut pas dépasser $currentYear";
    }

    return null;
  }

  static String? validateRating(String? value) {
    if (value == null || value.isEmpty) {
      return 'La note est requise';
    }

    final double? rating = double.tryParse(value);
    if (rating == null) {
      return 'Veuillez entrer un nombre valide';
    }

    if (rating < 0 || rating > 5) {
      return 'La note doit être comprise entre 0 et 5';
    }

    return null;
  }

  static String? validationLocationPrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le prix de location est réquis';
    }

    final phoneRegExp = RegExp(r'^(?:[+0]9)?[0-9]{5}$');
    if (!phoneRegExp.hasMatch(value)) {
      return "Format de numéro invalide (05 chiffres requis)";
    }

    return null;
  }

  static String? validationIFUNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de Téléphone est réquis';
    }

    final phoneRegExp = RegExp(r'^(?:[+0]9)?[0-9]{13}$');
    if (!phoneRegExp.hasMatch(value)) {
      return "Format de numéro de IFU invalide (13 chiffres requis)";
    }

    return null;
  }

  static String? validationMeasureNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de Téléphone est réquis';
    }

    final phoneRegExp = RegExp(r'^(?:[+0]9)?[0-9]{3}$');
    if (!phoneRegExp.hasMatch(value)) {
      return "Format de mesure invalide (3 chiffres requis)";
    }

    return null;
  }
}
