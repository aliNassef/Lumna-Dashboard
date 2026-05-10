import '../../../../core/extensions/padding_extension.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/spacer.dart';
import '../widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static const String routeName = 'login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: const LoginViewBody().withHorizontalPadding(
            Spacing.extraLarge,
          ),
        ),
      ),
    );
  }
}
