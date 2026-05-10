import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_dialog_extension.dart';
import '../../../../core/navigation/app_navigation.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/validator/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../core/widgets/loading_icon_indicator_button.dart';
import '../../data/models/signup_request.dart';
import '../controller/auth_cubit/auth_cubit.dart';
import '../views/login_view.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _fullNameController;
  late final GlobalKey<FormState> _formKey;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _fullNameController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
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
          CustomTextFormField(
            controller: _fullNameController,
            hintText: LocaleKeys.auth_full_name.tr(),
            prefixIcon: Icons.person_outline,
            validator: Validators.fullNameValidator,
            keyboardType: TextInputType.name,
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

          CustomTextFormField(
            controller: _passwordController,
            hintText: LocaleKeys.auth_password_required.tr(),
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
          const Gap(16),

          const Gap(30),
          BlocConsumer<AuthCubit, AuthState>(
            buildWhen: (previous, current) =>
                current is AuthLoading ||
                current is AuthSuccess ||
                current is AuthError,
            listener: (context, state) {
              if (state is AuthSuccess) {
                context.pushAndRemoveUntil(
                  LoginView.routeName,
                  (p0) => false,
                );
              }
              if (state is AuthError) {
                context.showAppDialog(
                  title: 'Error',
                  message: state.failure.errMessage,
                  isSuccess: false,
                );
              }
            },
            builder: (context, state) {
              return CustomButton(
                isDisabled: state is AuthLoading,
                icon: Center(
                  child: LoadingIconIndicatorButton(
                    isLoading: state is AuthLoading,
                  ),
                ),
                text: LocaleKeys.create_account.tr(),
                onPressed: () {
                  _signup(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _signup(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final req = SignupRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
      );
      context.read<AuthCubit>().signup(req);
    }
  }
}
