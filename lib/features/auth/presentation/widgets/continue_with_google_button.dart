import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';

class ContinueWithGoogleButton extends StatelessWidget {
  const ContinueWithGoogleButton({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.large,
        ),
        decoration: BoxDecoration(
          color: context.colors.onPrimary,
          borderRadius: BorderRadius.circular(Shape.large),
        ),
        child: Row(
          mainAxisAlignment: .center,
          children: [
            SvgPicture.asset(
              AppAssets.googleIcon,
              height: 20,
              width: 20,
            ),
            const Gap(10),
            Text(
              LocaleKeys.auth_continue_google.tr(),
              style: context.typography.medium14.copyWith(
                color: context.colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
