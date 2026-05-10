import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/exceptions/failure.dart';
import '../../../../../core/translation/locale_keys.g.dart';
import '../../../data/models/card_stats_model.dart';
import '../../../data/repo/statistics_repo.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit({required this.homeRepo}) : super(StatisticsInitial());

  final StatisticsRepo homeRepo;

  Future<void> getDashboardSummary() async {
    emit(StatisticsLoading());

    final summaryOrFailure = await homeRepo.getDashboardSummary();
    summaryOrFailure.fold(
      (failure) => emit(StatisticsError(failure: failure)),
      (
        summary,
      ) {
        final stats = [
          CardStatsModel(
            title: LocaleKeys.total_sales,
            amount: summary.totalSales.toStringAsFixed(2),
            percentage: summary.formattedSalesGrowth,
            icon: Icons.account_balance_wallet_outlined,
          ),
          CardStatsModel(
            title: LocaleKeys.new_orders,
            amount: summary.totalOrders.toString(),
            percentage: summary.formattedOrdersGrowth,
            icon: Icons.shopping_bag_outlined,
          ),
          CardStatsModel(
            title: LocaleKeys.active_products,
            amount: summary.activeProductsCount.toString(),
            percentage: '0%',
            icon: Icons.inventory_2_outlined,
          ),
        ];
        emit(StatisticsLoaded(stats: stats));
      },
    );
  }
}
