import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/di/di.dart';
import 'package:lumna_admin/core/di/injection_container.dart';

import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_button.dart';
import 'offer_form_dialog.dart';

class OffersHeader extends StatelessWidget {
  const OffersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(Spacing.extraLarge),
        Text(
          LocaleKeys.offers_title.tr(),
          style: context.typography.bold24.copyWith(
            color: context.colors.onSurface,
          ),
        ),
        const Gap(Spacing.small),
        Text(
          LocaleKeys.offers_desc.tr(),
          style: context.typography.regular16.copyWith(
            color: context.colors.onTertiary,
          ),
        ),
        const Gap(Spacing.extraLarge),
        CustomButton(
          text: LocaleKeys.offer_add.tr(),
          icon: Icon(Icons.add, color: context.colors.onPrimary),
          onPressed: () => showOfferFormDialog(context),
        ),
      ],
    ).withHorizontalPadding(Spacing.extraLarge);
  }

  void showOfferFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: injector<ProductCubit>()..getProducts(),
        child: BlocProvider.value(
          value: context.read<OfferCubit>(),
          child: const OfferFormDialog(),
        ),
      ),
    );
  }
}
