import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/translation/locale_keys.g.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import 'time_line_item.dart';

class OrderTimelineCard extends StatelessWidget {
  const OrderTimelineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.colors.onPrimary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleKeys.section_order_timeline.tr(), style: context.typography.bold20),
          const Gap(24),

          TimelineItem(
            title: LocaleKeys.timeline_order_placed.tr(),
            subtitle: LocaleKeys.timeline_order_placed_date.tr(),
            description:
                LocaleKeys.timeline_order_placed_desc.tr(),
            icon: Icon(
              Icons.check_circle,
              color: context.colors.primary,
              size: 24,
            ),
          ),

          TimelineItem(
            title: LocaleKeys.timeline_processing_title.tr(),
            subtitle: LocaleKeys.timeline_processing_status.tr(),
            description: LocaleKeys.timeline_processing_desc.tr(),
            isLast: true,
            icon: Icon(
              Icons.inventory_2_outlined,
              color: Colors.grey[400],
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
