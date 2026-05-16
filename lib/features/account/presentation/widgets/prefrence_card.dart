import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/extensions/app_dialog_extension.dart';
import 'package:lumna_admin/core/navigation/navigation.dart';
import 'package:lumna_admin/features/notification/presentation/view/send_notification_view.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import 'preference_tile.dart';

class PreferencesCard extends StatelessWidget {
  const PreferencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: Spacing.medium,
            bottom: Spacing.large,
          ),
          child: Text(
            LocaleKeys.section_preferences.tr(),
            style: context.typography.bold14.copyWith(
              color: context.colors.primary,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(Spacing.extraLarge),
          decoration: BoxDecoration(
            color: context.colors.onPrimary,
            borderRadius: BorderRadius.circular(Shape.extraLarge),
          ),
          child: Column(
            children: [
              PreferenceTile(
                icon: Icons.notifications_none_outlined,
                title: LocaleKeys.notifications_title.tr(),
                onTap: () {
                  context.pushNamed(
                    SendNotificationView.routeName,
                    arguments: const NavArgs(
                      animation: NavAnimation.fade,
                    ),
                  );
                },
              ),
              const Gap(Spacing.extraLarge),
              PreferenceTile(
                icon: Icons.translate,
                title: LocaleKeys.language_title.tr(),
                trailingText: context.locale.countryCode == 'en'
                    ? LocaleKeys.english.tr()
                    : LocaleKeys.arabic.tr(),
                onTap: () {
                  context.showLangSheet();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
