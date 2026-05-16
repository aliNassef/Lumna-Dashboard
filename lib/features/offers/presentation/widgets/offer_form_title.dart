import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';

class OfferFormTitle extends StatelessWidget {
  const OfferFormTitle({super.key, required this.isEditing});

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Text(
      isEditing ? LocaleKeys.offer_edit.tr() : LocaleKeys.offer_add.tr(),
      style: context.typography.bold24.copyWith(
        color: context.colors.onSurface,
      ),
    );
  }
}
