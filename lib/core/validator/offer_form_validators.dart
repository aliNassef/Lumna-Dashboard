import 'package:easy_localization/easy_localization.dart';

import '../translation/locale_keys.g.dart';
import 'validators.dart';

abstract class OfferFormValidators {
  static String? validatePercent(String? value) {
    final requiredError = Validators.fieldIsRequired(value);
    if (requiredError != null) return requiredError;

    final percent = num.tryParse(value!.trim());
    if (percent == null || percent < 1 || percent > 100) {
      return LocaleKeys.offer_percent_error.tr();
    }
    return null;
  }

  static String? validateEndDate({
    required String? value,
    required DateTime? startsAt,
    required DateTime? endsAt,
  }) {
    final requiredError = Validators.fieldIsRequired(value);
    if (requiredError != null) return requiredError;
    if (startsAt == null || endsAt == null) {
      return LocaleKeys.error_field_required.tr();
    }
    if (!endsAt.isAfter(startsAt)) {
      return LocaleKeys.offer_date_error.tr();
    }
    return null;
  }
}
