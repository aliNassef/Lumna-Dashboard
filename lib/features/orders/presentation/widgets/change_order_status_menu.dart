import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/order_status.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import '../controller/orders_cubit/orders_cubit.dart';

class ChangeOrderStatusMenu extends StatelessWidget {
  const ChangeOrderStatusMenu({super.key, required this.orderId});
  final String orderId;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: null,
      style: context.typography.regular16.copyWith(
        // color: context.colors.onSurface,
      ),
      hint: Text(
        LocaleKeys.change_status.tr(),
        style: context.typography.regular16.copyWith(
          color: context.colors.onPrimary,
        ),
      ),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: context.colors.onPrimary,
      ),
      dropdownColor: context.colors.primary,
      decoration: InputDecoration(
        filled: true,
        fillColor: context.colors.primary,
        contentPadding: const EdgeInsets.symmetric(
          vertical: Spacing.extraLarge,
          horizontal: Spacing.large,
        ),
        border: _buildBorder(context),
        enabledBorder: _buildBorder(context),
        focusedBorder: _buildBorder(context),
      ),
      items: OrderStatus.values
          .map(
            (status) => DropdownMenuItem(
              value: status.value,
              child: Text(
                status.value,
              ),
            ),
          )
          .toList(),

      onChanged: (value) {
        context.read<OrdersCubit>().updateOrderStatus(
          orderId,
          OrderStatus.fromValue(value!),
        );
      },
    );
  }

  OutlineInputBorder _buildBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(Shape.large)),
      borderSide: BorderSide(color: context.colors.outline),
    );
  }
}
