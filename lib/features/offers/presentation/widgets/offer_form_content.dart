import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import '../../data/models/offer_model.dart';
import '../controller/offer_cubit/offer_cubit.dart';
import 'offer_form_fields.dart';

class OfferFormContent extends StatelessWidget {
  const OfferFormContent({
    super.key,
    required this.formKey,
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

  final GlobalKey<FormState> formKey;
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
    return Dialog(
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Shape.extraLarge),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.extraLarge),
        child: Form(
          key: formKey,
          child: OfferFormFields(
            state: state,
            offer: offer,
            title: title,
            discount: discount,
            startsAtText: startsAtText,
            endsAtText: endsAtText,
            startsAt: startsAt,
            endsAt: endsAt,
            productId: productId,
            isActive: isActive,
            onProductChanged: onProductChanged,
            onActiveChanged: onActiveChanged,
            onPickStartDate: onPickStartDate,
            onPickEndDate: onPickEndDate,
            onCancel: onCancel,
            onSave: onSave,
          ),
        ),
      ),
    );
  }
}
