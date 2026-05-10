import 'package:flutter/material.dart';

import '../utils/theme/app_text_style.dart';

extension TypographyExtension on BuildContext {
  AppTextStyle get typography => Theme.of(this).extension<AppTextStyle>()!;
}
