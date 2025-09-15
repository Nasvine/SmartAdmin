import 'package:get/get.dart';

class TFormatException implements Exception {
  /// The error code associated with the exception
  final String code;

  /// Constructor
  TFormatException([this.code = 'unknown']);

  /// Create a format exception from a specific error message
  factory TFormatException.fromMessage(String message) {
    return TFormatException(message);
  }

  /// Get the corresponding translated message
  String get formattedMessage {
    switch (code) {
      case 'invalid-email-format':
        return 'format.invalid_email'.tr;
      case 'invalid-phone-number-format':
        return 'format.invalid_phone'.tr;
      case 'invalid-date-format':
        return 'format.invalid_date'.tr;
      case 'invalid-url-format':
        return 'format.invalid_url'.tr;
      default:
        return 'format.unknown'.tr;
    }
  }

  /// Create a format exception from a specific error code
  factory TFormatException.fromCode(String code) {
    return TFormatException(code);
  }
}
