import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/app_dialog_extension.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/navigation/app_navigation.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/views/login_view.dart';
import '../controller/account_cubit/account_cubit.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountCubit, AccountState>(
      listener: (context, state) {
        if (state.status.isLogoutSuccess) {
          context.pushAndRemoveUntil(
            LoginView.routeName,
            (context) => true,
          );
        }
        if (state.status.isLogoutFailure) {
          context.pop();
          context.showToast(
            text: state.failure?.errMessage ?? 'Failed to logout',
            backgroundColor: context.colors.error,
          );
        }
        if (state.status.isLoggingOut) {
          context.showLoadingBox();
        }
      },
      child: CustomButton(
        text: 'Logout',
        backgroundColor: context.colors.onError,
        textColor: context.colors.error,
        onPressed: () {
          context.read<AccountCubit>().logout();
        },
      ),
    );
  }
}
