import 'package:get/get.dart';

class TFirebaseException implements Exception {
  final String code;

  TFirebaseException(this.code);

  String get message {
    switch (code) {
      case 'unknown':
        return 'firebase.unknown'.tr;
      case 'invalid-custom-token':
        return 'firebase.invalid_custom_token'.tr;
      case 'custom-token-mismatch':
        return 'firebase.custom_token_mismatch'.tr;
      case 'user-disabled':
        return 'firebase.user_disabled'.tr;
      case 'user-not-found':
        return 'firebase.user_not_found'.tr;
      case 'wrong-password':
        return 'firebase.wrong_password'.tr;
      case 'weak-password':
        return 'firebase.weak_password'.tr;
      case 'invalid-verification-code':
        return 'firebase.invalid_verification_code'.tr;
      case 'invalid-verification-id':
        return 'firebase.invalid_verification_id'.tr;
      case 'quota-exceeded':
        return 'firebase.quota_exceeded'.tr;
      case 'email-already-exists':
        return 'firebase.email_already_exists'.tr;
      case 'provider-already-linked':
        return 'firebase.provider_already_linked'.tr;
      case 'requires-recent-login':
        return 'firebase.requires_recent_login'.tr;
      case 'credential-already-in-use':
        return 'firebase.credential_already_in_use'.tr;
      case 'user-mismatch':
        return 'firebase.user_mismatch'.tr;
      case 'account-exists-with-different-credential':
        return 'firebase.account_exists_with_different_credential'.tr;
      case 'operation-not-allowed':
        return 'firebase.operation_not_allowed'.tr;
      case 'invalid-action-code':
        return 'firebase.invalid_action_code'.tr;
      case 'expired-action-code':
        return 'firebase.expired_action_code'.tr;
      case 'missing-action-code':
        return 'firebase.missing_action_code'.tr;
      case 'user-token-expired':
        return 'firebase.user_token_expired'.tr;
      case 'invalid-credential':
        return 'firebase.invalid_credential'.tr;
      case 'user-token-revoked':
        return 'firebase.user_token_revoked'.tr;
      case 'invalid-message-payload':
        return 'firebase.invalid_message_payload'.tr;
      case 'invalid-sender':
        return 'firebase.invalid_sender'.tr;
      default:
        return 'firebase.unknown'.tr;
    }
  }
}
