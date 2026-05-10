import '../extensions/strings_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import '../translation/locale_keys.g.dart';

class Validators {
  static String? emailValidator(String? value) {
    if (value.isNullOrEmpty) {
      return LocaleKeys.error_invalid_email.tr();
    }
    if (!value!.contains('@')) {
      return LocaleKeys.error_invalid_email.tr();
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value.isNullOrEmpty) {
      return LocaleKeys.error_invalid_password.tr();
    }
    if (value!.length < 8) {
      return LocaleKeys.error_invalid_password.tr();
    }
    return null;
  }

  static String? fullNameValidator(String? value) {
    if (value.isNullOrEmpty) {
      return LocaleKeys.error_full_name_required.tr();
    }
    return null;
  }

  static String? fieldIsRequired(String? value) {
    if (value.isNullOrEmpty) {
      return LocaleKeys.error_field_required.tr();
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String password) {
    if (value.isNullOrEmpty) {
      return LocaleKeys.error_invalid_password.tr();
    }
    if (value != password) {
      return LocaleKeys.error_passwords_dont_match.tr();
    }
    return null;
  }

  static String? descriptionValidator(String? value) {
    if (value.isNullOrEmpty || value!.length < 50) {
      return LocaleKeys.field_description_hint.tr();
    }
    return null;
  }

  static String? commentValidator(String? value) {
    if (value.isNullOrEmpty) {
      // Replaced hardcoded string with localized key
      return LocaleKeys.error_comment_required.tr();
    }
    return null;
  }
}
