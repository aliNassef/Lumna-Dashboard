import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import '../extensions/color_extensions.dart';
import '../extensions/typography_extension.dart';
import '../navigation/app_navigation.dart';
import '../utils/spacer.dart';
import '../utils/shape.dart';
import '../widgets/custom_button.dart';

extension DialogExtension on BuildContext {
  void showAppDialog({
    required String title,
    required String message,
    required bool isSuccess,
    String? buttonText,
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: this,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Shape.medium),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(Spacing.large),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(Shape.medium),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Header with subtle circular background
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: isSuccess
                      ? Colors.green.withValues(alpha: 0.1)
                      : context.colors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                  color: isSuccess ? Colors.green : context.colors.error,
                  size: 40,
                ),
              ),
              const Gap(Spacing.medium),

              // Title
              Text(
                title,
                style: context.typography.bold20.copyWith(
                  color: context.colors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(Spacing.small),

              // Message
              Text(
                message,
                style: context.typography.regular14.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(Spacing.large),

              CustomButton(
                text: buttonText ?? (isSuccess ? 'Continue' : 'Dismiss'),
                backgroundColor: isSuccess
                    ? Colors.green
                    : context.colors.error,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                  if (onConfirm != null) onConfirm();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showInfoDialog({required String title, required String message}) {
    final navigator = Navigator.of(this);
    Future.delayed(const Duration(seconds: 3), () {
      if (navigator.canPop()) {
        navigator.pop();
      }
    });
    showDialog(
      context: this,
      builder: (context) => Dialog(
        insetAnimationDuration: const Duration(seconds: 2),
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.all(Spacing.large),
          decoration: BoxDecoration(
            color: const Color(0xffACEDDA),
            borderRadius: BorderRadius.circular(Shape.extraLarge),
          ),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              Icon(
                Icons.info_outline,
                color: context.colors.primary,
              ),
              const Gap(Spacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: context.typography.semiBold14.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    const Gap(Spacing.small),
                    Flexible(
                      child: Text(
                        message,
                        style: context.typography.regular12.copyWith(
                          color: context.colors.primary.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showToast({
    required String text,
    required Color backgroundColor,
  }) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.sp,
    );
  }

  Future<dynamic> showLoadingBox() {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(
                colors.primary,
              ),
              backgroundColor: colors.onPrimary,
            ),
          ),
        );
      },
    );
  }

  void showComingSoonDialog() {
    showDialog(
      context: this,
      builder: (_) => const ComingSoonDialog(),
    );
  }
}

class ComingSoonDialog extends StatelessWidget {
  const ComingSoonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = context.colors.primary;

    return Dialog(
      // Using Shape.extraLarge (22.0.r) for the dialog corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Shape.extraLarge),
      ),
      elevation: 0,
      backgroundColor: context.colors.onPrimary,
      child: Padding(
        // Using Spacing.extraLarge (16.0) for internal padding
        padding: const EdgeInsets.all(Spacing.extraLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(Spacing.large),
            // Illustrative Icon
            Container(
              padding: const EdgeInsets.all(Spacing.extraLarge),
              decoration: BoxDecoration(
                color: context.colors.onPrimary,
                borderRadius: BorderRadius.circular(Shape.medium),
              ),
              child: Icon(
                Icons.rocket_launch_outlined,
                color: primaryGreen,
                size: 48,
              ),
            ),
            const Gap(Spacing.extraLarge),
            // Text Content
            Text(
              'Coming Soon!',
              style: context.typography.bold24.copyWith(color: primaryGreen),
            ),
            const Gap(Spacing.medium),
            Text(
              "We're working hard to bring this feature to your dashboard. Stay tuned for updates!",
              textAlign: TextAlign.center,
              style: context.typography.regular14.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const Gap(
              Spacing.extraLarge,
            ),
            // Action Button
            CustomButton(
              text: 'GOT IT',
              onPressed: () => context.pop(),
              radius: Shape.large,
            ),
          ],
        ),
      ),
    );
  }
}
