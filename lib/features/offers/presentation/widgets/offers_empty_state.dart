import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/mediaquery_size.dart';

import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/widgets/empty_list_data.dart';
import '../controller/offer_cubit/offer_cubit.dart';

class OffersEmptyState extends StatelessWidget {
  const OffersEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: context.height * .5,
        child: EmptyListData(
          text: LocaleKeys.offers_empty.tr(),
          icon: Icons.local_offer_outlined,
          onRefresh: context.read<OfferCubit>().getOffersData,
        ),
      ),
    );
  }
}
