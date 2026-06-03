import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/translation/locale_keys.g.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/navigation/app_navigation.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import '../views/map_location_view.dart';
import 'preference_tile.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
  });

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
            LocaleKeys.section_location.tr(),
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
          child: PreferenceTile(
            icon: Icons.location_on_outlined,
            title: LocaleKeys.manage_store_location.tr(),
            onTap: () {
              context.pushNamed(MapLocationView.routeName);
            },
          ),
        ),
      ],
    );
  }
}
