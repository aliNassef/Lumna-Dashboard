import 'package:easy_localization/easy_localization.dart';
import '../../../../core/widgets/loading_icon_indicator_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/app_dialog_extension.dart';
import '../../../../core/navigation/navigation.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/validator/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../controller/auth_cubit/auth_cubit.dart';
import 'continue_with_google_button.dart';
import 'having_account_question.dart';
import 'or_dvider.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            LocaleKeys.auth_welcome.tr(),
            style: context.typography.bold32.copyWith(
              color: context.colors.primary,
            ),
          ),
          const Gap(8),
          Text(
            LocaleKeys.auth_email_required.tr(),
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

          CustomTextFormField(
            controller: _passwordController,
            hintText: LocaleKeys.auth_password_required.tr(),
            validator: Validators.passwordValidator,
            prefixIcon: Icons.lock_outline,
            keyboardType: TextInputType.visiblePassword,
            isPassowrd: true,
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                LocaleKeys.auth_forgot_password.tr(),
                style: context.typography.medium14.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ),
          ),

          const Gap(30),
          BlocConsumer<AuthCubit, AuthState>(
            buildWhen: (previous, current) =>
                current is AuthLoading ||
                current is AuthSuccess ||
                current is AuthError,
            listener: (context, state) {
              if (state is AuthSuccess) {
                context.pushAndRemoveUntil(
                  LayoutView.routeName,
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
                icon: LoadingIconIndicatorButton(
                  isLoading: state is AuthLoading,
                ),
                text: LocaleKeys.auth_login.tr(),
                onPressed: () {
                  _signin(context);
                },
              );
            },
          ),
          const Gap(30),
          const OrDvider(),
          const Gap(40),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {},
            child: const ContinueWithGoogleButton(),
          ),
          const Gap(40),
          HavingAccountQuestion(
            question: LocaleKeys.auth_no_account.tr(),
            actionText: LocaleKeys.auth_signup.tr(),
            onTap: () => _goToSignup(context),
          ),
        ],
      ),
    );
  }

  void _signin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signin(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  void _goToSignup(BuildContext context) {
    context.pushNamed(
      SignupView.routeName,
      arguments: const NavArgs(
        animation: NavAnimation.fade,
      ),
    );
  }
}
