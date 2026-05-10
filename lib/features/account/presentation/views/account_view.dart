import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumna_admin/core/di/di.dart';
import 'package:lumna_admin/core/extensions/padding_extension.dart';
import 'package:lumna_admin/core/utils/spacer.dart';
import 'package:lumna_admin/core/widgets/custom_app_bar.dart';

import '../../../../core/di/injection_container.dart';
import '../widgets/account_view_body.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Admin Account',
        actionPadding: 20,
        showBackButton: false,
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => injector<AccountCubit>()..getCurrentProfile(),
          child: SingleChildScrollView(
            child: const AccountViewBody().withHorizontalPadding(
              Spacing.extraLarge,
            ),
          ),
        ),
      ),
    );
  }
}
