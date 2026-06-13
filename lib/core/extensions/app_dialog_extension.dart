import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import '../translation/locale_keys.g.dart';
import '../extensions/color_extensions.dart';
import '../extensions/typography_extension.dart';
import '../utils/spacer.dart';
import '../utils/shape.dart';
import '../widgets/coming_soon_dialog.dart';
import '../widgets/custom_button.dart';
import '../widgets/language_bottom_sheet.dart';

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
                text: buttonText ?? (isSuccess ? LocaleKeys.continue_action.tr() : LocaleKeys.dismiss.tr()),
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

  void showLangSheet() {
    showModalBottomSheet(
      context: this,
      backgroundColor: colors.onPrimary,
      builder: (context) => const SafeArea(
        child: LanguageBottomSheet(),
      ),
    );
  }
}
