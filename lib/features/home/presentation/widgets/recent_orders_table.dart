import 'package:data_table_2/data_table_2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/extensions/order_status.dart';
import '../../../../core/utils/shape.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/spacer.dart';
import '../../../orders/data/models/recent_order_model.dart';

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
                    DataCell(_OrderIdCell(id: order.id)),
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

class _OrderIdCell extends StatelessWidget {
  const _OrderIdCell({required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Text(
      id,
      style: context.typography.bold14.copyWith(color: context.colors.primary),
    );
  }
}

class CustomerCell extends StatelessWidget {
  const CustomerCell({
    super.key,
    required this.name,
    required this.initials,
  });

  final String name;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: context.colors.primary,
          backgroundImage: initials != 'N/A' ? NetworkImage(initials) : null,
        ),
        const Gap(Spacing.medium),
        Expanded(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: context.typography.bold14,
          ),
        ),
      ],
    );
  }
}

class DateCell extends StatelessWidget {
  const DateCell({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Text(
      date,
      style: context.typography.medium12.copyWith(
        color: context.colors.primaryContainer,
      ),
    );
  }
}

class StatusCell extends StatelessWidget {
  const StatusCell({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.medium,
          vertical: Spacing.small,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: context.typography.medium12.copyWith(color: textColor),
        ),
      ),
    );
  }
}
