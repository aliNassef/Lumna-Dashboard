import 'package:easy_localization/easy_localization.dart';

import '../../../../core/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';

import 'having_account_question.dart';
import 'signup_form.dart';

class SignupViewBody extends StatelessWidget {
  const SignupViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const Gap(40),
        Text(
          LocaleKeys.create_account.tr(),
          style: context.typography.bold32.copyWith(
            color: context.colors.primary,
          ),
        ),
        const Gap(8),
        Text(
          LocaleKeys.app_name.tr(),
          style: context.typography.medium16.copyWith(
            color: context.colors.primaryContainer,
          ),
        ),
        const Gap(30),
        const SignupForm(),
        // agree terms.
        const Gap(40),
        HavingAccountQuestion(
          question: LocaleKeys.auth_have_account.tr(),
          actionText: LocaleKeys.auth_login.tr(),
          onTap: () => _goToLogin(context),
        ),
        const Gap(40),
      ],
    );
  }

  void _goToLogin(BuildContext context) {
    context.pop();
  }
}
