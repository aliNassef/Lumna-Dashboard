import 'package:easy_localization/easy_localization.dart';

extension StringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension DigitLocalization on String {
  /// Converts Western digits (0-9) to Arabic-Indic digits (٠-٩) when the
  /// active locale is Arabic. Returns the string unchanged otherwise.
  /// Locale follows [Intl.defaultLocale], set in `AdminApp.build`.
  String get localizeDigits {
    if (!(Intl.defaultLocale?.startsWith('ar') ?? false)) return this;
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var result = this;
    for (var i = 0; i < western.length; i++) {
      result = result.replaceAll(western[i], arabic[i]);
    }
    return result;
  }
}
