import 'package:data_table_2/data_table_2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/order_status.dart';
import '../../../../core/utils/shape.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../orders/data/models/recent_order_model.dart';
import 'customer_cell.dart';
import 'date_cell.dart';
import 'order_id_cell.dart';
import 'status_cell.dart';

class RecentOrdersTable extends StatelessWidget {
  const RecentOrdersTable({
    super.key,
    required this.orders,
  });

  static const double _headingRowHeight = 56;
  static const double _dataRowHeight = 72;
  static const double _tableMinWidth = 720;

  final List<RecentOrderModel> orders;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.onPrimary,
        borderRadius: BorderRadius.circular(Shape.extraLarge),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Shape.extraLarge),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: context.colors.outline.withValues(
              alpha: 0.5,
            ),
            dataTableTheme: DataTableThemeData(
              headingRowColor: WidgetStatePropertyAll(context.colors.outline),
              dataRowColor: WidgetStatePropertyAll(context.colors.onPrimary),
              horizontalMargin: 20,
              columnSpacing: 16,
              dividerThickness: 1,
              headingTextStyle: context.typography.medium12.copyWith(
                color: context.colors.primaryContainer.withValues(alpha: 0.7),
                letterSpacing: 1.1,
              ),
            ),
          ),
          child: SizedBox(
            height: _headingRowHeight + (_dataRowHeight * orders.length),
            width: double.infinity,
            child: DataTable2(
              minWidth: _tableMinWidth,
              showCheckboxColumn: false,
              headingRowHeight: _headingRowHeight,
              dataRowHeight: _dataRowHeight,
              smRatio: 0.9,
              lmRatio: 1.4,
              columns: [
                DataColumn2(
                  label: Text(LocaleKeys.orders_order_id.tr()),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text(LocaleKeys.orders_customer.tr()),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text(LocaleKeys.orders_date.tr()),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: Text(LocaleKeys.orders_status.tr()),
                  size: ColumnSize.S,
                ),
              ],
              rows: orders.map((order) {
                return DataRow(
                  cells: [
                    DataCell(OrderIdCell(id: '#${order.orderNumber}')),
                    DataCell(
                      CustomerCell(
                        initials: order.customerImage ?? 'N/A',
                        name: order.customerName,
                      ),
                    ),
                    DataCell(DateCell(date: order.date.toString())),
                    DataCell(
                      StatusCell(
                        backgroundColor: order.status.chipBackgroundColor,
                        textColor: order.status.chipTextColor,
                        label: order.status.value,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
