import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/utils/spacer.dart';
import '../controller/forgot_password_cubit/forgot_password_cubit.dart';
import '../widgets/forgot_password_body.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});
  static const String routeName = 'forgot_password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (_) => injector<ForgotPasswordCubit>(),
            child: const ForgotPasswordBody(),
          ).withHorizontalPadding(Spacing.extraLarge),
        ),
      ),
    );
  }
}
