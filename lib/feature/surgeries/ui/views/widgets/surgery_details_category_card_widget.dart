import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medivault/core/utils/app_colors.dart';

class SurgeryDetailsCategoryCardWidget extends StatelessWidget {
  final String specialty;
  final String surgeryName;
  final String date;

  const SurgeryDetailsCategoryCardWidget({
    super.key,
    required this.specialty,
    required this.surgeryName,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.fieldBorder.withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.checkboxBorder,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  specialty,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bannerBg,
                  ),
                ),
              ),
              Text(
                date,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryGrey,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            surgeryName,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.darkNavyText,
            ),
          ),
        ],
      ),
    );
  }
}
