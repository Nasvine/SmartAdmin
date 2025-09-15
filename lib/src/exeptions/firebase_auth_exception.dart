import 'package:get/get.dart';

class TFirebaseAuthException implements Exception {
  final String code;

  TFirebaseAuthException(this.code);

  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'auth.email_already_in_use'.tr;
      case 'invalid-email':
        return 'auth.invalid_email'.tr;
      case 'weak-password':
        return 'auth.weak_password'.tr;
      case 'user-disabled':
        return 'auth.user_disabled'.tr;
      case 'user-not-found':
        return 'auth.user_not_found'.tr;
      case 'wrong-password':
        return 'auth.wrong_password'.tr;
      case 'invalid-verification-code':
        return 'auth.invalid_verification_code'.tr;
      case 'invalid-verification-id':
        return 'auth.invalid_verification_id'.tr;
      case 'quota-exceeded':
        return 'auth.quota_exceeded'.tr;
      case 'email-already-exists':
        return 'auth.email_already_exists'.tr;
      case 'provider-already-linked':
        return 'auth.provider_already_linked'.tr;
      case 'requires-recent-login':
        return 'auth.requires_recent_login'.tr;
      case 'credential-already-in-use':
        return 'auth.credential_already_in_use'.tr;
      case 'user-mismatch':
        return 'auth.user_mismatch'.tr;
      case 'account-exists-with-different-credential':
        return 'auth.account_exists_with_different_credential'.tr;
      case 'operation-not-allowed':
        return 'auth.operation_not_allowed'.tr;
      case 'invalid-action-code':
        return 'auth.invalid_action_code'.tr;
      case 'expired-action-code':
        return 'auth.expired_action_code'.tr;
      case 'missing-action-code':
        return 'auth.missing_action_code'.tr;
      case 'user-token-expired':
        return 'auth.user_token_expired'.tr;
      case 'invalid-credential':
        return 'auth.invalid_credential'.tr;
      case 'user-token-revoked':
        return 'auth.user_token_revoked'.tr;
      case 'invalid-message-payload':
        return 'auth.invalid_message_payload'.tr;
      case 'invalid-sender':
        return 'auth.invalid_sender'.tr;
      default:
        return 'auth.unknown'.tr;
    }
  }
}
