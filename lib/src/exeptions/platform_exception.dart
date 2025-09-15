import 'package:get/get.dart';


class TPlatformException implements Exception {
  final String code;

  TPlatformException(this.code);

  String get message {
    switch (code) {
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'platform.invalid_login_credentials'.tr;
      case 'too-many-requests':
        return 'platform.too_many_requests'.tr;
      case 'invalid-argument':
        return 'platform.invalid_argument'.tr;
      case 'invalid-password':
        return 'platform.invalid_password'.tr;
      case 'invalid-phone-number':
        return 'platform.invalid_phone_number'.tr;
      case 'operation-not-allowed':
        return 'platform.operation_not_allowed'.tr;
      case 'session-cookie-expired':
        return 'platform.session_cookie_expired'.tr;
      case 'uid-already-exists':
        return 'platform.uid_already_exists'.tr;
      case 'sign_in_failed':
        return 'platform.sign_in_failed'.tr;
      case 'network-request-failed':
        return 'platform.network_request_failed'.tr;
      case 'internal-error':
        return 'platform.internal_error'.tr;
      case 'invalid-verification-code':
        return 'platform.invalid_verification_code'.tr;
      case 'invalid-verification-id':
        return 'platform.invalid_verification_id'.tr;
      case 'quota-exceeded':
        return 'platform.quota_exceeded'.tr;
      default:
        return 'platform.unexpected_error'.tr;
    }
  }
}
