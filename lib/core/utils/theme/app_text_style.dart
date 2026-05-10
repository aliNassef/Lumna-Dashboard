import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle extends ThemeExtension<AppTextStyle> {
  final TextStyle medium16;
  final TextStyle medium20;
  final TextStyle medium24;
  final TextStyle medium14;
  final TextStyle medium12;
  final TextStyle regular12;
  final TextStyle regular14;
  final TextStyle regular16;
  final TextStyle regular10;
  final TextStyle bold16;
  final TextStyle bold14;
  final TextStyle bold20;
  final TextStyle bold32;
  final TextStyle bold24;
  final TextStyle bold40;
  final TextStyle bold10;
  final TextStyle semiBold16;
  final TextStyle semiBold20;
  final TextStyle semiBold14;
  final TextStyle semiBold12;
  final TextStyle semiBold10;
  final TextStyle extraBold24;
  final TextStyle bold12;
  final TextStyle bold18;

  const AppTextStyle({
    required this.medium16,
    required this.medium20,
    required this.medium24,
    required this.medium14,
    required this.medium12,
    required this.regular12,
    required this.regular14,
    required this.regular16,
    required this.regular10,
    required this.bold16,
    required this.bold14,
    required this.bold32,
    required this.bold20,
    required this.bold24,
    required this.bold40,
    required this.bold10,
    required this.semiBold16,
    required this.semiBold20,
    required this.semiBold14,
    required this.semiBold12,
    required this.semiBold10,
    required this.extraBold24,
    required this.bold12,
    required this.bold18,
  });

  @override
  ThemeExtension<AppTextStyle> copyWith({
    TextStyle? medium16,
    TextStyle? medium20,
    TextStyle? medium24,
    TextStyle? medium14,
    TextStyle? medium12,
    TextStyle? regular12,
    TextStyle? regular14,
    TextStyle? regular16,
    TextStyle? regular10,
    TextStyle? bold16,
    TextStyle? bold14,
    TextStyle? bold32,
    TextStyle? bold20,
    TextStyle? bold24,
    TextStyle? bold40,
    TextStyle? bold10,
    TextStyle? semiBold16,
    TextStyle? semiBold20,
    TextStyle? semiBold14,
    TextStyle? semiBold12,
    TextStyle? semiBold10,

    TextStyle? extraBold24,

    TextStyle? bold12,
    TextStyle? bold18,
  }) {
    return AppTextStyle(
      regular16: regular16 ?? this.regular16,
      bold10: bold10 ?? this.bold10,
      bold20: bold20 ?? this.bold20,
      bold32: bold32 ?? this.bold32,
      bold24: bold24 ?? this.bold24,
      bold40: bold40 ?? this.bold40,
      semiBold16: semiBold16 ?? this.semiBold16,
      semiBold20: semiBold20 ?? this.semiBold20,
      semiBold14: semiBold14 ?? this.semiBold14,
      semiBold12: semiBold12 ?? this.semiBold12,
      semiBold10: semiBold10 ?? this.semiBold10,
      extraBold24: extraBold24 ?? this.extraBold24,
      bold12: bold12 ?? this.bold12,
      medium16: medium16 ?? this.medium16,
      medium20: medium20 ?? this.medium20,
      medium24: medium24 ?? this.medium24,
      medium14: medium14 ?? this.medium14,
      medium12: medium12 ?? this.medium12,
      regular12: regular12 ?? this.regular12,
      regular14: regular14 ?? this.regular14,
      regular10: regular10 ?? this.regular10,
      bold16: bold16 ?? this.bold16,
      bold18: bold18 ?? this.bold18,
      bold14: bold14 ?? this.bold14,
    );
  }

  @override
  ThemeExtension<AppTextStyle> lerp(
    covariant ThemeExtension<AppTextStyle>? other,
    double t,
  ) {
    if (other is! AppTextStyle) return this;
    return AppTextStyle(
      bold10: TextStyle.lerp(bold10, other.bold10, t)!,
      bold20: TextStyle.lerp(bold20, other.bold20, t)!,
      regular16: TextStyle.lerp(regular16, other.regular16, t)!,
      medium16: TextStyle.lerp(medium16, other.medium16, t)!,
      medium20: TextStyle.lerp(medium20, other.medium20, t)!,
      bold32: TextStyle.lerp(bold32, other.bold32, t)!,
      bold24: TextStyle.lerp(bold24, other.bold24, t)!,
      bold40: TextStyle.lerp(bold40, other.bold40, t)!,
      semiBold16: TextStyle.lerp(semiBold16, other.semiBold16, t)!,
      semiBold20: TextStyle.lerp(semiBold20, other.semiBold20, t)!,
      semiBold14: TextStyle.lerp(semiBold14, other.semiBold14, t)!,
      semiBold12: TextStyle.lerp(semiBold12, other.semiBold12, t)!,
      semiBold10: TextStyle.lerp(semiBold10, other.semiBold10, t)!,
      extraBold24: TextStyle.lerp(extraBold24, other.extraBold24, t)!,
      bold12: TextStyle.lerp(bold12, other.bold12, t)!,
      medium24: TextStyle.lerp(medium24, other.medium24, t)!,
      medium14: TextStyle.lerp(medium14, other.medium14, t)!,
      medium12: TextStyle.lerp(medium12, other.medium12, t)!,
      regular12: TextStyle.lerp(regular12, other.regular12, t)!,
      regular14: TextStyle.lerp(regular14, other.regular14, t)!,
      regular10: TextStyle.lerp(regular10, other.regular10, t)!,
      bold16: TextStyle.lerp(bold16, other.bold16, t)!,
      bold14: TextStyle.lerp(bold14, other.bold14, t)!,
      bold18: TextStyle.lerp(bold18, other.bold18, t)!,
    );
  }

  static final light = AppTextStyle(
    bold20: GoogleFonts.plusJakartaSans(
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
    ),
    bold24: GoogleFonts.plusJakartaSans(
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
    ),
    bold40: GoogleFonts.plusJakartaSans(
      fontSize: 40.sp,
      fontWeight: FontWeight.w700,
    ),
    bold10: GoogleFonts.plusJakartaSans(
      fontSize: 10.sp,
      fontWeight: FontWeight.w700,
    ),
    semiBold16: GoogleFonts.plusJakartaSans(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
    ),
    semiBold20: GoogleFonts.plusJakartaSans(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
    ),
    semiBold14: GoogleFonts.plusJakartaSans(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    ),
    semiBold12: GoogleFonts.plusJakartaSans(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    ),
    semiBold10: GoogleFonts.plusJakartaSans(
      fontSize: 10.sp,
      fontWeight: FontWeight.w600,
    ),
    extraBold24: GoogleFonts.plusJakartaSans(
      fontSize: 24.sp,
      fontWeight: FontWeight.w800,
    ),
    bold12: GoogleFonts.plusJakartaSans(
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
    ),
    regular16: GoogleFonts.plusJakartaSans(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
    ),
    medium16: GoogleFonts.plusJakartaSans(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
    ),
    medium20: GoogleFonts.plusJakartaSans(
      fontSize: 20.sp,
      fontWeight: FontWeight.w500,
    ),
    bold32: GoogleFonts.plusJakartaSans(
      fontSize: 32.sp,
      fontWeight: FontWeight.w700,
    ),
    medium24: GoogleFonts.plusJakartaSans(
      fontSize: 24.sp,
      fontWeight: FontWeight.w500,
    ),
    medium14: GoogleFonts.plusJakartaSans(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
    ),
    medium12: GoogleFonts.plusJakartaSans(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
    ),
    regular12: GoogleFonts.plusJakartaSans(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
    ),
    regular14: GoogleFonts.plusJakartaSans(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
    ),
    regular10: GoogleFonts.plusJakartaSans(
      fontSize: 10.sp,
      fontWeight: FontWeight.w400,
    ),
    bold16: GoogleFonts.plusJakartaSans(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
    ),
    bold14: GoogleFonts.plusJakartaSans(
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
    ),
    bold18: GoogleFonts.plusJakartaSans(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
    ),
  );

  static final dark = AppTextStyle(
    bold20: GoogleFonts.plusJakartaSans(
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
    ),
    bold32: GoogleFonts.plusJakartaSans(
      fontSize: 32.sp,
      fontWeight: FontWeight.w700,
    ),
    bold24: GoogleFonts.plusJakartaSans(
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
    ),
    bold40: GoogleFonts.plusJakartaSans(
      fontSize: 40.sp,
      fontWeight: FontWeight.w700,
    ),
    bold18: GoogleFonts.plusJakartaSans(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
    ),
    bold10: GoogleFonts.plusJakartaSans(
      fontSize: 10.sp,
      fontWeight: FontWeight.w700,
    ),
    semiBold16: GoogleFonts.plusJakartaSans(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
    ),
    semiBold20: GoogleFonts.plusJakartaSans(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
    ),
    semiBold14: GoogleFonts.plusJakartaSans(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    ),
    semiBold12: GoogleFonts.plusJakartaSans(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    ),
    semiBold10: GoogleFonts.plusJakartaSans(
      fontSize: 10.sp,
      fontWeight: FontWeight.w600,
    ),
    extraBold24: GoogleFonts.plusJakartaSans(
      fontSize: 24.sp,
      fontWeight: FontWeight.w800,
    ),
    bold12: GoogleFonts.plusJakartaSans(
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
    ),
    regular16: GoogleFonts.plusJakartaSans(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
    ),
    medium16: GoogleFonts.plusJakartaSans(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
    ),
    medium20: GoogleFonts.plusJakartaSans(
      fontSize: 20.sp,
      fontWeight: FontWeight.w500,
    ),
    medium24: GoogleFonts.plusJakartaSans(
      fontSize: 24.sp,
      fontWeight: FontWeight.w500,
    ),
    medium14: GoogleFonts.plusJakartaSans(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
    ),
    medium12: GoogleFonts.plusJakartaSans(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
    ),
    regular12: GoogleFonts.plusJakartaSans(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
    ),
    regular14: GoogleFonts.plusJakartaSans(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
    ),
    regular10: GoogleFonts.plusJakartaSans(
      fontSize: 10.sp,
      fontWeight: FontWeight.w400,
    ),
    bold16: GoogleFonts.plusJakartaSans(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
    ),
    bold14: GoogleFonts.plusJakartaSans(
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
    ),
  );
}
