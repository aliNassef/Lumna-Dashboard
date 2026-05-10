import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/spacer.dart';
import 'location_card.dart';
import 'logout_button.dart';
import 'prefrence_card.dart';
import 'profile_header_builder.dart';
import 'support_card.dart';

class AccountViewBody extends StatelessWidget {
  const AccountViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Gap(Spacing.extraLarge),
        ProfileHeaderBuilder(),
        Gap(Spacing.extraLarge),
        PreferencesCard(),
        Gap(Spacing.extraLarge),
        LocationCard(),
        Gap(Spacing.extraLarge),
        SupportCard(),
        Gap(Spacing.extraLarge),
        LogoutButton(),
        Gap(Spacing.extraExtraLarge),
      ],
    );
  }
}
