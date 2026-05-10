
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/utils/spacer.dart';
import '../widgets/signup_view_body.dart';
import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});
  static const String routeName = 'signup';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: const SignupViewBody().withHorizontalPadding(
            Spacing.extraLarge,
          ),
        ),
      ),
    );
  }
}
