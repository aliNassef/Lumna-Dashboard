import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/widgets/custom_failure_widget.dart';
import 'package:lumna_admin/features/products/presentation/controller/product_cubit/product_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/spacer.dart';
import '../../data/models/offer_model.dart';
import '../controller/offer_cubit/offer_cubit.dart';
import 'offer_active_switch.dart';
import 'offer_date_field.dart';
import 'offer_form_actions.dart';
import 'offer_form_title.dart';
import 'offer_product_dropdown.dart';
import 'offer_text_fields.dart';

class OfferFormFields extends StatelessWidget {
  const OfferFormFields({
    super.key,
    required this.state,
    required this.title,
    required this.discount,
    required this.startsAtText,
    required this.endsAtText,
    required this.isActive,
    required this.onProductChanged,
    required this.onActiveChanged,
    required this.onPickStartDate,
    required this.onPickEndDate,
    required this.onCancel,
    required this.onSave,
    this.offer,
    this.startsAt,
    this.endsAt,
    this.productId,
  });

  final OfferState state;
  final OfferModel? offer;
  final TextEditingController title;
  final TextEditingController discount;
  final TextEditingController startsAtText;
  final TextEditingController endsAtText;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String? productId;
  final bool isActive;
  final ValueChanged<String?> onProductChanged;
  final ValueChanged<bool> onActiveChanged;
  final VoidCallback onPickStartDate;
  final VoidCallback onPickEndDate;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OfferFormTitle(isEditing: offer != null),
        const Gap(Spacing.extraLarge),
        BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            return switch (state.status) {
              ProductStatus.loadingProducts => Skeletonizer(
                child: OfferProductDropdown(
                  value: productId,
                  products: [],
                  onChanged: onProductChanged,
                ),
              ),
              ProductStatus.failureProducts => CustomFailureWidget(
                failure: state.failure!,
              ),
              ProductStatus.successProducts => OfferProductDropdown(
                value: productId,
                products: state.allProducts,
                onChanged: onProductChanged,
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
        const Gap(Spacing.large),
        OfferTextFields(title: title, discount: discount),
        const Gap(Spacing.large),
        OfferDateField(controller: startsAtText, onTap: onPickStartDate),
        const Gap(Spacing.large),
        OfferDateField(
          controller: endsAtText,
          startsAt: startsAt,
          endsAt: endsAt,
          isEndDate: true,
          onTap: onPickEndDate,
        ),
        const Gap(Spacing.large),
        OfferActiveSwitch(value: isActive, onChanged: onActiveChanged),
        const Gap(Spacing.extraLarge),
        OfferFormActions(
          isLoading: state.status.isSaving,
          onCancel: onCancel,
          onSave: onSave,
        ),
      ],
    );
  }
}
