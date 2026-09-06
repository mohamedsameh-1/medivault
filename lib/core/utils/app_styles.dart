import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppStyles {
  static TextStyle w700S28DarkNavy = GoogleFonts.inter(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.darkNavyText,
  );

  static TextStyle w700S24DarkNavy = GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.darkNavyText,
  );

  static TextStyle w400S14Grey = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryGrey,
    height: 1.5,
  );

  static TextStyle w600S14PrimaryTeal = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryTeal,
  );

  static TextStyle w600S16White = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle w600S16PrimaryTeal = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryTeal,
  );

  static TextStyle w500S12BadgeGreen = GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.badgeGreenText,
  );
}
