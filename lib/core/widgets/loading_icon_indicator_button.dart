import '../extensions/color_extensions.dart';
import 'package:flutter/material.dart';

class LoadingIconIndicatorButton extends StatelessWidget {
  const LoadingIconIndicatorButton({
    super.key,
    this.isLoading = false,
  });
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? CircularProgressIndicator(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: context.colors.onPrimary,
              constraints: const BoxConstraints(
                maxHeight: 60,
                minHeight: 25,
                minWidth: 25,
                maxWidth: 60,
              ),
            )
          : null,
    );
  }
}
