import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_app_bar.dart';

import '../widgets/account_view_body.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: LocaleKeys.admin_account_title.tr(),
        actionPadding: 20,
        showBackButton: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: const AccountViewBody().withHorizontalPadding(
            Spacing.extraLarge,
          ),
        ),
      ),
    );
  }
}
