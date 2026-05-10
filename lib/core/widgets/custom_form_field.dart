import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/color_extensions.dart';
import '../extensions/typography_extension.dart';
import '../utils/shape.dart';
import '../utils/spacer.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.controller,
    this.validator,
    this.isPassowrd = false,
    this.maxLines = 1,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
  });
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isPassowrd;
  final int? maxLines;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool isSecure;

  @override
  void initState() {
    super.initState();
    isSecure = widget.isPassowrd;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: context.colors.secondary,
      cursorHeight: 20.sp,
      keyboardType: widget.keyboardType,
      focusNode: widget.focusNode,
      style: context.typography.medium16.copyWith(
        color: context.colors.onSurface,
      ),
      obscureText: isSecure,
      obscuringCharacter: '●',
      maxLines: widget.maxLines,
      controller: widget.controller,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: Spacing.extraLarge,
          horizontal: Spacing.large,
        ),

        prefixIconConstraints: const BoxConstraints(
          minWidth: 36,
          minHeight: Spacing.extraLarge,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                size: Spacing.extraLarge,
                color: context.colors.primary,
              )
            : null,
        suffixIcon: widget.isPassowrd
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isSecure = !isSecure;
                  });
                },
                child: isSecure
                    ? Icon(
                        Icons.visibility_off,
                        color: context.colors.secondary,
                        size: 20.sp,
                      )
                    : Icon(
                        Icons.visibility,
                        color: context.colors.secondary,
                        size: 20.sp,
                      ),
              )
            : null,
        hintText: widget.hintText,
        hintStyle: context.typography.regular12.copyWith(
          color: const Color(0xff617589),
        ),
        errorStyle: context.typography.bold10.copyWith(
          color: context.colors.error,
        ),
        border: _buildBorder(),
        enabledBorder: _buildBorder(),
        focusedBorder: _buildBorder(),
        errorBorder: _buildBorder(color: context.colors.error),
        filled: true,
        fillColor: context.colors.onPrimary,
      ),
    );
  }

  OutlineInputBorder _buildBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(Shape.large)),
      borderSide: BorderSide(color: color ?? context.colors.outline),
    );
  }
}
