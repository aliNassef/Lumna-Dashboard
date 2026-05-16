import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/di/di.dart';
import 'package:lumna_admin/core/di/injection_container.dart';

import '../../../../core/utils/spacer.dart';
import '../../data/models/offer_model.dart';
import '../controller/offer_cubit/offer_cubit.dart';
import 'offer_card.dart';
import 'offer_form_dialog.dart';

class OffersList extends StatelessWidget {
  const OffersList({super.key, required this.offers});

  final List<OfferModel> offers;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.extraLarge),
      sliver: SliverList.separated(
        itemBuilder: (context, index) {
          final offer = offers[index];
          return OfferCard(
            offer: offer,
            productName: '',
            onEdit: () => showOfferFormDialog(context, offer),
            onDelete: () => context.read<OfferCubit>().deleteOffer(offer.id!),
          );
        },
        separatorBuilder: (context, index) => const Gap(Spacing.large),
        itemCount: offers.length,
      ),
    );
  }

  void showOfferFormDialog(BuildContext context, OfferModel offer) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: injector<ProductCubit>(),
        child: BlocProvider.value(
          value: context.read<OfferCubit>(),
          child: OfferFormDialog(offer: offer),
        ),
      ),
    );
  }
}
