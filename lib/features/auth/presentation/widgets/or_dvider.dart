import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';

class OrDvider extends StatelessWidget {
  const OrDvider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 1,
            color: context.colors.outlineVariant,
            endIndent: 10,
          ),
        ),
        Text(
          LocaleKeys.or.tr(),
          style: context.typography.medium14.copyWith(
            color: context.colors.primary,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: context.colors.outlineVariant,
            indent: 10,
          ),
        ),
      ],
    );
  }
}
