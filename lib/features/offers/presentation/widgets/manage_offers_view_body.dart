import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../controller/offer_cubit/offer_cubit.dart';
import 'offers_content.dart';
import 'offers_header.dart';

class ManageOffersViewBody extends StatelessWidget {
  const ManageOffersViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: const SizedBox.shrink(),
          leadingWidth: 0,
          backgroundColor: context.colors.onPrimary,
          title: CustomAppbar(title: LocaleKeys.offers_title.tr()),
        ),
        const SliverToBoxAdapter(child: OffersHeader()),
        const SliverGap(Spacing.extraLarge),
        BlocBuilder<OfferCubit, OfferState>(
          builder: (context, state) {
            return OffersContent(state: state);
          },
        ),
        const SliverGap(Spacing.extraExtraLarge),
      ],
    );
  }
}
