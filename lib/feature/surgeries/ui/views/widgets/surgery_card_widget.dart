import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/core/utils/medical_special_list.dart';
import 'package:medivault/feature/surgeries/domain/entities/surgery_entity.dart';

class SurgeryCardWidget extends StatelessWidget {
  final SurgeryEntity surgery;
  final VoidCallback? onTap;

  const SurgeryCardWidget({super.key, required this.surgery, this.onTap});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'dd MMM yyyy',
    ).format(surgery.surgeryDate);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldBorder, width: 1),
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
                        // Top Row: Specialty Tag + Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryTeal,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                MedicalSpecialties.getSpecialtyTitle(
                                  surgery.specialty,
                                ),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.bannerBg,
                                ),
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryGrey,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        // Main Content Row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    surgery.surgeryName,
                                    style: AppStyles.w700S24DarkNavy.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  SizedBox(height: 4.h),

                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person_outline_rounded,
                                        size: 14.sp,
                                        color: AppColors.secondaryGrey,
                                      ),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        child: Text(
                                          surgery.doctorName,
                                          style: AppStyles.w400S14Grey.copyWith(
                                            fontSize: 12.sp,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 2.h),

                                  Row(
                                    children: [
                                      Icon(
                                        Icons.local_hospital_outlined,
                                        size: 14.sp,
                                        color: AppColors.secondaryGrey,
                                      ),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        child: Text(
                                          surgery.hospitalName,
                                          style: AppStyles.w400S14Grey.copyWith(
                                            fontSize: 12.sp,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Trailing Chevron
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 22.sp,
                              color: AppColors.iconGrey,
                            ),
                          ],
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
