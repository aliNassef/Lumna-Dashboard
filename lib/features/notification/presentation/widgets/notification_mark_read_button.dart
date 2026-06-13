import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/spacer.dart';

class MarkAllAsReadButton extends StatelessWidget {
  const MarkAllAsReadButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.extraLarge,
        vertical: Spacing.medium,
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          child: Text(LocaleKeys.mark_all_as_read.tr()),
        ),
      ),
    );
  }
}
