import 'package:equatable/equatable.dart';

import '../../../../core/extensions/strings_extensions.dart';

class DashboardStatsModel extends Equatable {
  final double totalSales;
  final double salesGrowthPercentage;
  final int totalOrders;
  final double ordersGrowthPercentage;
  final int activeProductsCount;

  const DashboardStatsModel({
    required this.totalSales,
    required this.salesGrowthPercentage,
    required this.totalOrders,
    required this.ordersGrowthPercentage,
    required this.activeProductsCount,
  });

  factory DashboardStatsModel.fromMap(Map<String, dynamic> map) {
    return DashboardStatsModel(
      totalSales: (map['total_sales'] ?? 0.0).toDouble(),
      salesGrowthPercentage: (map['sales_growth'] ?? 0.0).toDouble(),
      totalOrders: (map['total_orders'] ?? 0).toInt(),
      ordersGrowthPercentage: (map['orders_growth'] ?? 0.0).toDouble(),
      activeProductsCount: (map['active_products'] ?? 0).toInt(),
    );
  }

  String get formattedSalesGrowth =>
      '${salesGrowthPercentage >= 0 ? '+' : ''}${salesGrowthPercentage.toStringAsFixed(1)}%'
          .localizeDigits;

  String get formattedOrdersGrowth =>
      '${ordersGrowthPercentage >= 0 ? '+' : ''}${ordersGrowthPercentage.toStringAsFixed(1)}%'
          .localizeDigits;

  @override
  List<Object?> get props => [
    totalSales,
    salesGrowthPercentage,
    totalOrders,
    ordersGrowthPercentage,
    activeProductsCount,
  ];
}
