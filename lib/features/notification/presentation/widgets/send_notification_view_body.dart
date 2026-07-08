import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/services/notification/notification_type.dart';
import '../../../../core/extensions/app_dialog_extension.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_form_field.dart';

import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/media_upload_card.dart';
import '../../data/models/send_notification_request.dart';
import '../controller/notification_cubit/notification_cubit.dart';

class SendNotificationViewBody extends StatefulWidget {
  const SendNotificationViewBody({super.key});

  @override
  State<SendNotificationViewBody> createState() =>
      _SendNotificationViewBodyState();
}

class _SendNotificationViewBodyState extends State<SendNotificationViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _selectedType = 'general';

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          context.showToast(
            text: LocaleKeys.notification_sent_successfully.tr(),
            backgroundColor: Colors.green,
          );
          _titleController.clear();
          _bodyController.clear();
          setState(() => _selectedType = 'general');
          context.read<NotificationCubit>().resetForm();
        }

        if (state.status.isFailure && state.failure != null) {
          context.showToast(
            text: state.failure!.errMessage,
            backgroundColor: context.colors.error,
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.extraLarge),
                decoration: BoxDecoration(
                  color: context.colors.onPrimary,
                  borderRadius: BorderRadius.circular(Shape.extraLarge),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.section_notification_details.tr(),
                      style: context.typography.bold24.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    const Gap(24),
                    Text(
                      LocaleKeys.label_notification_title.tr(),
                      style: context.typography.semiBold12.copyWith(
                        color: context.colors.onTertiary,
                      ),
                    ),
                    const Gap(Spacing.small),
                    CustomTextFormField(
                      hintText: LocaleKeys.hint_enter_title.tr(),
                      controller: _titleController,
                      validator: _validateRequired,
                    ),
                    const Gap(24),
                    Text(
                      LocaleKeys.notification_type_push.tr(),
                      style: context.typography.semiBold12.copyWith(
                        color: context.colors.onTertiary,
                      ),
                    ),
                    const Gap(Spacing.small),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: NotificationType.general.name,
                          child: Text(
                            LocaleKeys.notification_type_general.tr(),
                          ),
                        ),
                        DropdownMenuItem(
                          value: NotificationType.offer.name,
                          child: Text(LocaleKeys.notification_type_offer.tr()),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedType = value);
                        }
                      },
                    ),
                    const Gap(24),
                    Text(
                      LocaleKeys.label_message_body.tr(),
                      style: context.typography.semiBold12.copyWith(
                        color: context.colors.onTertiary,
                      ),
                    ),
                    const Gap(Spacing.small),
                    CustomTextFormField(
                      hintText: LocaleKeys.hint_enter_message_body.tr(),
                      controller: _bodyController,
                      validator: _validateRequired,
                      maxLines: 4,
                    ),
                    const Gap(24),
                    Text(
                      LocaleKeys.label_upload_image.tr(),
                      style: context.typography.semiBold12.copyWith(
                        color: context.colors.onTertiary,
                      ),
                    ),
                    const Gap(Spacing.small),
                    GestureDetector(
                      onTap: state.status.isSending
                          ? null
                          : () => context.read<NotificationCubit>().pickImage(),
                      child: MediaUploadCard(
                        isLoading: state.status.isPickingImage,
                        imageUrl: state.pickedImage,
                      ),
                    ),
                    const Gap(Spacing.small),
                    Text(
                      LocaleKeys.image_preview_optional.tr(),
                      style: context.typography.regular12.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const Gap(50),
                  ],
                ),
              ),
              const Gap(Spacing.extraLarge),
              CustomButton(
                text: state.status.isSending
                    ? LocaleKeys.broadcasting.tr()
                    : LocaleKeys.broadcast_notification.tr(),
                isDisabled: state.status.isSending,
                onPressed: state.status.isSending ? null : _submit,
                icon: Icon(
                  Icons.broadcast_on_personal_rounded,
                  color: context.colors.onPrimary,
                ),
              ),
              const Gap(Spacing.extraExtraLarge),
            ],
          ),
        );
      },
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.this_field_is_required.tr();
    }
    return null;
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final cubit = context.read<NotificationCubit>();
    cubit.sendNotification(
      SendNotificationRequest(
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        type: _selectedType,
      ),
    );
  }
}
