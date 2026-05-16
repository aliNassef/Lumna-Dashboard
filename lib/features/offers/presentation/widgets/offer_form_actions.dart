import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_button.dart';

class OfferFormActions extends StatelessWidget {
  const OfferFormActions({
    super.key,
    required this.isLoading,
    required this.onCancel,
    required this.onSave,
  });

  final bool isLoading;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: onCancel,
            child: Text(LocaleKeys.cancel.tr()),
          ),
        ),
        const Gap(Spacing.large),
        Expanded(
          flex: 2,
          child: CustomButton(
            text: isLoading
                ? LocaleKeys.creating.tr()
                : LocaleKeys.save_changes.tr(),
            onPressed: isLoading ? null : onSave,
          ),
        ),
      ],
    );
  }
}
