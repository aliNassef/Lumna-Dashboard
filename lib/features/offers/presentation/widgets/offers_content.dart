import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_failure_widget.dart';
import '../controller/offer_cubit/offer_cubit.dart';
import 'offers_empty_state.dart';
import 'offers_list.dart';
import 'offers_loading_list.dart';

class OffersContent extends StatelessWidget {
  const OffersContent({super.key, required this.state});

  final OfferState state;

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      OfferStatus.loading => const OffersLoadingList(),
      OfferStatus.failure when state.failure != null => SliverToBoxAdapter(
        child: CustomFailureWidget(failure: state.failure!),
      ),
      OfferStatus.success =>
        state.offers.isEmpty
            ? const OffersEmptyState()
            : OffersList(
                offers: state.offers,
              ),
      _ => const OffersEmptyState(),
    };
  }
}
