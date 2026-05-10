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
        return 'cash';
      case PaymentMethod.credit:
        return 'credit';
    }
  }
}
