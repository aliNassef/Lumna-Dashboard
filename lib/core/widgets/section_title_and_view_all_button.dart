import 'package:easy_localization/easy_localization.dart';
import '../extensions/typography_extension.dart';
import '../translation/locale_keys.g.dart';
import 'package:flutter/material.dart';

import '../extensions/color_extensions.dart';

class SectionTitleAndViewAllButton extends StatelessWidget {
  const SectionTitleAndViewAllButton({
    super.key,
    required this.sectionTitle,
    this.onPressed,
  });
  final String sectionTitle;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          sectionTitle,
          style: context.typography.bold20.copyWith(
            color: context.colors.onSurface,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: onPressed,
          child: Text(
            LocaleKeys.dashboard_view_all.tr(),
            style: context.typography.semiBold14.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
