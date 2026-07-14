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

class UpdatePasswordBody extends StatefulWidget {
  const UpdatePasswordBody({super.key});

  @override
  State<UpdatePasswordBody> createState() => _UpdatePasswordBodyState();
}

class _UpdatePasswordBodyState extends State<UpdatePasswordBody> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          const Gap(40),
          Text(
            LocaleKeys.auth_update_password.tr(),
            style: context.typography.bold32.copyWith(
              color: context.colors.primary,
            ),
          ),
          const Gap(30),
          CustomTextFormField(
            controller: _passwordController,
            hintText: LocaleKeys.auth_new_password.tr(),
            validator: Validators.passwordValidator,
            prefixIcon: Icons.lock_outline,
            keyboardType: TextInputType.visiblePassword,
            isPassowrd: true,
          ),
          const Gap(30),
          CustomTextFormField(
            controller: _confirmPasswordController,
            hintText: LocaleKeys.auth_confirm_password.tr(),
            validator: (value) => Validators.confirmPasswordValidator(
              value,
              _passwordController.text.trim(),
            ),
            prefixIcon: Icons.lock_outline,
            keyboardType: TextInputType.visiblePassword,
            isPassowrd: true,
          ),
          const Gap(30),
          BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordUpdated) {
                context.showAppDialog(
                  title: LocaleKeys.auth_update_password.tr(),
                  message: LocaleKeys.auth_password_updated.tr(),
                  isSuccess: true,
                  onConfirm: () => context.pushAndRemoveUntil(
                    LoginView.routeName,
                    (_) => false,
                  ),
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
                text: LocaleKeys.auth_update_password.tr(),
                onPressed: () => _updatePassword(context),
              );
            },
          ),
        ],
      ),
    );
  }

  void _updatePassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ForgotPasswordCubit>().updatePassword(
        _passwordController.text.trim(),
      );
    }
  }
}
