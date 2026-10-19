import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';

class VisitTimelineCardWidget extends StatelessWidget {
  final VisitEntity visit;
  final VoidCallback onTap;

  const VisitTimelineCardWidget({
    super.key,
    required this.visit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM dd, yyyy').format(visit.visitDate);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.bannerBg, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.fieldBorder,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 5.w, color: AppColors.primaryTeal),
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formattedDate,
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkNavyText,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 20.r,
                              color: AppColors.iconGrey,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Icon(
                              Icons.medical_information_outlined,
                              size: 16.r,
                              color: AppColors.primaryTeal,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              visit.doctorName,
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkNavyText,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Icon(
                              Icons.business_outlined,
                              size: 16.r,
                              color: AppColors.secondaryGrey,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                visit.clinicHospital,
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.secondaryGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: AppColors.screenBg,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.reasonForVisit.tr().toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: AppColors.secondaryGrey,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                visit.symptoms,
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.darkNavyText,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
