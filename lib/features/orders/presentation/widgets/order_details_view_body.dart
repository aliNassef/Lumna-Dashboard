import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/extensions/padding_extension.dart';
import 'payment_info_card.dart';
import 'shipping_address_card.dart';

import '../../../../core/utils/spacer.dart';
import '../../data/models/order_details_model.dart';
import 'customer_details_card.dart';
import 'order_details_header.dart';

class OrderDetailsViewBody extends StatelessWidget {
  const OrderDetailsViewBody({super.key, required this.orderDetailsModel});
  final OrderDetailsModel orderDetailsModel;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverGap(Spacing.extraLarge),
        SliverToBoxAdapter(
          child:
              OrderDetailHeader(
                orderDetailsModel: orderDetailsModel,
              ).withHorizontalPadding(
                Spacing.extraLarge,
              ),
        ),
        // todo :change order status time line.
        // const SliverGap(Spacing.extraLarge),
        // SliverToBoxAdapter(
        //   child: const OrderTimelineCard().withHorizontalPadding(
        //     Spacing.extraLarge,
        //   ),
        // ),
        const SliverGap(Spacing.extraLarge),
        SliverToBoxAdapter(
          child:
              CustomerDetailCard(
                orderDetailsModel: orderDetailsModel,
              ).withHorizontalPadding(
                Spacing.extraLarge,
              ),
        ),
        const SliverGap(Spacing.extraLarge),
        SliverToBoxAdapter(
          child:
              ShippingAddressCard(
                city: orderDetailsModel.addressCity ?? '',
                country: orderDetailsModel.addressCountry ?? '',
                label: orderDetailsModel.addressLabel ?? '',
                street: orderDetailsModel.addressStreet ?? '',
              ).withHorizontalPadding(
                Spacing.extraLarge,
              ),
        ),
        const SliverGap(Spacing.extraLarge),
        SliverToBoxAdapter(
          child:
              PaymentInfoCard(
                paymentMethod: orderDetailsModel.paymentMethod,
              ).withHorizontalPadding(
                Spacing.extraLarge,
              ),
        ),
        const SliverGap(Spacing.extraLarge),
      ],
    );
  }
}
