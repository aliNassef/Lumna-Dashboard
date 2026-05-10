import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    return BlocBuilder<AccountCubit, AccountState>(
      buildWhen: (previous, current) =>
          current.status.isLoadingProfile ||
          current.status.isUpdatingProfile ||
          current.status.isProfileFailure ||
          current.status.isUpdateProfileFailure ||
          current.status.isProfileLoaded ||
          current.status.isUpdateProfileSuccess,
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
