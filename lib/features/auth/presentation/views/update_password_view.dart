import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/utils/spacer.dart';
import '../controller/forgot_password_cubit/forgot_password_cubit.dart';
import '../widgets/update_password_body.dart';

class UpdatePasswordView extends StatelessWidget {
  const UpdatePasswordView({super.key});
  static const String routeName = 'update_password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (_) => injector<ForgotPasswordCubit>(),
            child: const UpdatePasswordBody(),
          ).withHorizontalPadding(Spacing.extraLarge),
        ),
      ),
    );
  }
}
