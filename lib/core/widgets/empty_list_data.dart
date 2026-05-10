import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../extensions/color_extensions.dart';
import '../extensions/mediaquery_size.dart';
import '../extensions/typography_extension.dart';
import '../utils/spacer.dart';

class EmptyListData extends StatelessWidget {
  const EmptyListData({
    super.key,
    required this.text,
    required this.icon,
    this.onRefresh,
  });
  final String text;
  final IconData icon;
  final Future<void> Function()? onRefresh;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? () => Future.value(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Column(
                children: [
                  Gap(context.height * 0.2),
                  Icon(
                    icon,
                    size: 100,
                    color: context.colors.primary,
                  ),
                  const Gap(Spacing.extraLarge),
                  Text(
                    text,
                    style: context.typography.bold20.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                  const Gap(Spacing.extraLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
