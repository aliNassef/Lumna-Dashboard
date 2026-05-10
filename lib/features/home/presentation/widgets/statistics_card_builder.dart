import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_failure_widget.dart';
import '../../data/models/card_stats_model.dart';
import '../controller/statistics_cubit/statistics_cubit.dart';
import 'statistics_card.dart';

class StatisticsCardBuilder extends StatelessWidget {
  const StatisticsCardBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        return switch (state) {
          StatisticsLoading() => SliverSkeletonizer(
            enabled: true,
            child: SliverList.separated(
              itemBuilder: (_, index) => StatisticsCard(
                stat: dummyCardStats[index],
              ),
              separatorBuilder: (_, _) => const Gap(Spacing.extraLarge),
              itemCount: dummyCardStats.length,
            ),
          ),
          StatisticsLoaded(:final stats) => SliverList.separated(
            itemBuilder: (_, index) => StatisticsCard(
              stat: stats[index],
            ),
            separatorBuilder: (_, _) => const Gap(Spacing.extraLarge),
            itemCount: stats.length,
          ),

          StatisticsError() => SliverToBoxAdapter(
            child: CustomFailureWidget(failure: state.failure),
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
