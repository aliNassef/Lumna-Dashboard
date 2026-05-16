import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/navigation/app_navigation.dart';
import '../../data/models/offer_model.dart';
import '../controller/offer_cubit/offer_cubit.dart';
import 'offer_date_picker.dart';
import 'offer_form_content.dart';
import 'offer_form_side_effects.dart';

class OfferFormDialog extends StatefulWidget {
  const OfferFormDialog({super.key, this.offer});

  final OfferModel? offer;

  @override
  State<OfferFormDialog> createState() => _OfferFormDialogState();
}

class _OfferFormDialogState extends State<OfferFormDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController title;
  late final TextEditingController discount;
  late final TextEditingController startsAtText;
  late final TextEditingController endsAtText;
  late bool isActive;
  DateTime? startsAt;
  DateTime? endsAt;
  String? productId;

  @override
  void initState() {
    super.initState();
    final offer = widget.offer;
    title = TextEditingController(text: offer?.title);
    discount = TextEditingController(text: offer?.discountPercent.toString());
    startsAt = offer?.startsAt.toLocal();
    endsAt = offer?.endsAt.toLocal();
    startsAtText = TextEditingController(text: formatDate(startsAt));
    endsAtText = TextEditingController(text: formatDate(endsAt));
    isActive = offer?.isActive ?? true;
    productId = offer?.productId;
  }

  @override
  void dispose() {
    title.dispose();
    discount.dispose();
    startsAtText.dispose();
    endsAtText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OfferCubit, OfferState>(
      listener: OfferFormSideEffects.listen,
      builder: (context, state) => OfferFormContent(
        formKey: formKey,
        offer: widget.offer,
        state: state,
        title: title,
        discount: discount,
        startsAtText: startsAtText,
        endsAtText: endsAtText,
        startsAt: startsAt,
        endsAt: endsAt,
        productId: productId,
        isActive: isActive,
        onProductChanged: (value) => setState(() => productId = value),
        onActiveChanged: (value) => setState(() => isActive = value),
        onPickStartDate: () => pickDate(isStart: true),
        onPickEndDate: () => pickDate(isStart: false),
        onCancel: context.pop,
        onSave: saveOffer,
      ),
    );
  }

  Future<void> pickDate({required bool isStart}) async {
    final date = await OfferDatePicker.pick(
      context: context,
      startsAt: startsAt,
      endsAt: endsAt,
      isStart: isStart,
    );
    if (date == null) return;
    setState(() {
      if (isStart) {
        startsAt = DateTime(date.year, date.month, date.day);
        startsAtText.text = formatDate(startsAt);
      } else {
        endsAt = DateTime(date.year, date.month, date.day, 23, 59);
        endsAtText.text = formatDate(endsAt);
      }
    });
  }

  void saveOffer() {
    if (!formKey.currentState!.validate()) return;
    final offer = OfferModel(
      id: widget.offer?.id,
      productId: productId!,
      title: title.text.trim(),
      discountPercent: num.parse(discount.text.trim()),
      startsAt: startsAt!,
      endsAt: endsAt!,
      isActive: isActive,
    );
    context.read<OfferCubit>().saveOffer(offer);
  }

  String formatDate(DateTime? date) {
    return date?.monthDayYearText ?? '';
  }
}
