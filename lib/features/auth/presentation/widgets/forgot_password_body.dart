import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_dialog_extension.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/navigation/navigation.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/validator/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../core/widgets/loading_icon_indicator_button.dart';
import '../controller/forgot_password_cubit/forgot_password_cubit.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  late final TextEditingController _emailController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const Gap(20),
          Text(
            LocaleKeys.auth_reset_password_title.tr(),
            style: context.typography.bold32.copyWith(
              color: context.colors.primary,
            ),
          ),
          const Gap(8),
          Text(
            LocaleKeys.auth_reset_password_subtitle.tr(),
            style: context.typography.medium16.copyWith(
              color: context.colors.primaryContainer,
            ),
          ),
          const Gap(30),
          CustomTextFormField(
            controller: _emailController,
            hintText: LocaleKeys.auth_email_required.tr(),
            prefixIcon: Icons.email_outlined,
            validator: Validators.emailValidator,
            keyboardType: TextInputType.emailAddress,
          ),
          const Gap(30),
          BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordEmailSent) {
                context.showAppDialog(
                  title: LocaleKeys.auth_reset_password_title.tr(),
                  message: LocaleKeys.auth_reset_email_sent.tr(),
                  isSuccess: true,
                  onConfirm: () => context.pop(),
                );
              }
              if (state is ForgotPasswordError) {
                context.showAppDialog(
                  title: 'Error',
                  message: state.failure.errMessage,
                  isSuccess: false,
                );
              }
            },
            builder: (context, state) {
              return CustomButton(
                isDisabled: state is ForgotPasswordLoading,
                icon: LoadingIconIndicatorButton(
                  isLoading: state is ForgotPasswordLoading,
                ),
                text: LocaleKeys.auth_send_reset_link.tr(),
                onPressed: () => _sendResetLink(context),
              );
            },
          ),
        ],
      ),
    );
  }

  void _sendResetLink(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ForgotPasswordCubit>().sendResetEmail(
        _emailController.text.trim(),
      );
    }
  }
}
