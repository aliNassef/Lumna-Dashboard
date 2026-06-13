import 'package:easy_localization/easy_localization.dart';
import '../translation/locale_keys.g.dart';

enum PaymentMethod {
  cash,
  credit
  ;

  static PaymentMethod fromMap(Map<String, dynamic> map) {
    switch (map['value']) {
      case 'cash':
        return PaymentMethod.cash;
      case 'credit':
        return PaymentMethod.credit;
      default:
        return PaymentMethod.cash;
    }
  }
}

extension PaymentMethodExtension on PaymentMethod {
  String get value {
    switch (this) {
      case PaymentMethod.cash:
        return LocaleKeys.payment_method_cash.tr();
      case PaymentMethod.credit:
        return LocaleKeys.payment_method_credit.tr();
    }
  }
}
