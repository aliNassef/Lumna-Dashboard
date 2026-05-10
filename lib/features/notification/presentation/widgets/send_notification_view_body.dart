import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/extensions/app_dialog_extension.dart';
import 'package:lumna_admin/core/extensions/color_extensions.dart';
import 'package:lumna_admin/core/widgets/custom_button.dart';
import 'package:lumna_admin/core/widgets/custom_form_field.dart';

import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/media_upload_card.dart';
import '../../data/models/send_notification_request.dart';
import '../controller/notification_cubit/notification_cubit.dart';
import 'targeting_card.dart';

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
            text: 'Notification sent successfully',
            backgroundColor: Colors.green,
          );
          _titleController.clear();
          _bodyController.clear();
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
                      'Notification Details',
                      style: context.typography.bold24.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    const Gap(24),
                    Text(
                      'NOTIFICATION TITLE',
                      style: context.typography.semiBold12.copyWith(
                        color: context.colors.onTertiary,
                      ),
                    ),
                    const Gap(Spacing.small),
                    CustomTextFormField(
                      hintText: 'enter title',
                      controller: _titleController,
                      validator: _validateRequired,
                    ),
                    const Gap(24),
                    Text(
                      'MESSAGE BODY',
                      style: context.typography.semiBold12.copyWith(
                        color: context.colors.onTertiary,
                      ),
                    ),
                    const Gap(Spacing.small),
                    CustomTextFormField(
                      hintText: 'enter message body',
                      controller: _bodyController,
                      validator: _validateRequired,
                      maxLines: 4,
                    ),
                    const Gap(24),
                    Text(
                      'UPLOAD IMAGE',
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
                      'Image preview is optional and is not sent in v1.',
                      style: context.typography.regular12.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const Gap(50),
                  ],
                ),
              ),
              const Gap(Spacing.extraLarge),
              const TargetingCard(),
              const Gap(Spacing.extraLarge),
              CustomButton(
                text: state.status.isSending
                    ? 'Broadcasting...'
                    : 'Broadcast Notification',
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
      return 'This field is required';
    }
    return null;
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    context.read<NotificationCubit>().sendNotification(
      SendNotificationRequest(
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      ),
    );
  }
}
