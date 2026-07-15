import 'package:easy_localization/easy_localization.dart';

import '../translation/locale_keys.g.dart';

extension PriceFormatting on num {
  /// Formats the value as a localized price, e.g. `124.50 EGP` / `١٢٤٫٥٠ ج.م`.
  ///
  /// Digits and separators follow the active locale via [Intl.defaultLocale],
  /// which is set in `AdminApp.build`.
  String get asPrice =>
      '${NumberFormat('#,##0.00').format(this)} ${LocaleKeys.currency.tr()}';
}
