import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/extensions/app_dialog_extension.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/widgets/custom_failure_widget.dart';
import '../../data/models/account_model.dart';
import '../controller/account_cubit/account_cubit.dart';
import 'profile_header.dart';

class ProfileHeaderBuilder extends StatelessWidget {
  const ProfileHeaderBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountState>(
      buildWhen: (previous, current) =>
          current.status.isLoadingProfile ||
          current.status.isUpdatingProfile ||
          current.status.isProfileFailure ||
          current.status.isUpdateProfileFailure ||
          current.status.isProfileLoaded ||
          current.status.isUpdateProfileSuccess,
      listenWhen: (previous, current) =>
          current.status.isUpdateProfileSuccess ||
          current.status.isUpdateProfileFailure,
      listener: (context, state) {
        if (state.status.isUpdateProfileSuccess) {
          context.showToast(
            text: LocaleKeys.profile_updated_successfully.tr(),
            backgroundColor: context.colors.primary,
          );
        }

        if (state.status.isUpdateProfileFailure && state.failure != null) {
          context.showToast(
            text: state.failure!.errMessage,
            backgroundColor: context.colors.error,
          );
        }
      },
      builder: (context, state) {
        return switch (state.status) {
          AccountStatus.loadingProfile ||
          AccountStatus.updatingProfile => Skeletonizer(
            enabled: true,
            child: ProfileHeader(
              account: dummyAccount,
            ),
          ),
          AccountStatus.profileLoaded ||
          AccountStatus.updateProfileSuccess => ProfileHeader(
            account: state.profile!,
          ),
          AccountStatus.profileFailure ||
          AccountStatus.updateProfileFailure => CustomFailureWidget(
            failure: state.failure!,
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
