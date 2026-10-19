import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/feature/add_visit/ui/views/models/specialty_model.dart';

class HistorySpecialtyCardWidget extends StatelessWidget {
  final SpecialtyModel specialty;
  final int visitCount;
  final VoidCallback onTap;

  const HistorySpecialtyCardWidget({
    super.key,
    required this.specialty,
    required this.visitCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Image.asset(
                height: 85.h,
                width: double.infinity,
                specialty.iconPath,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.medical_services_outlined,
                  size: 24.r,
                  color: AppColors.primaryTeal,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      specialty.title.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkNavyText,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Expanded(
                      child: Text(
                        specialty.description.tr(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryGrey,
                          height: 1.3,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        AppStrings.visitsCount.tr(
                          args: [visitCount.toString()],
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
