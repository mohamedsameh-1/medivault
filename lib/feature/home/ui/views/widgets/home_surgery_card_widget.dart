import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/core/utils/medical_special_list.dart';
import 'package:medivault/feature/surgeries/domain/entities/surgery_entity.dart';

class HomeSurgeryCardWidget extends StatelessWidget {
  final SurgeryEntity surgery;
  final VoidCallback? onTap;

  const HomeSurgeryCardWidget({super.key, required this.surgery, this.onTap});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'dd MMM yyyy',
    ).format(surgery.surgeryDate);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.checkboxBorder, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5.w,
                decoration: BoxDecoration(color: AppColors.primaryTeal),
              ),
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(16.r),
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row: Specialty in Teal uppercase + Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              MedicalSpecialties.getSpecialtyTitle(
                                surgery.specialty,
                              ).toUpperCase(),
                              style: AppStyles.w700S11PrimaryTeal,
                            ),
                            Text(formattedDate, style: AppStyles.w500S12Grey),
                          ],
                        ),

                        SizedBox(height: 8.h),

                        // Surgery Name
                        Row(
                          children: [
                            Icon(
                              Icons.medical_services,
                              size: 16.sp,
                              color: AppColors.iconGrey,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              surgery.surgeryName,
                              style: AppStyles.w700S16DarkNavy,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),

                        SizedBox(height: 4.h),

                        // Doctor Name
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline_rounded,
                              size: 16.sp,
                              color: AppColors.iconGrey,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              surgery.doctorName,
                              style: AppStyles.w400S13Grey,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 20.sp,
                              color: AppColors.iconGrey,
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),

                        // Hospital Name
                        Row(
                          children: [
                            Icon(
                              Icons.local_hospital_outlined,
                              size: 16.sp,
                              color: AppColors.iconGrey,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              surgery.hospitalName,
                              style: AppStyles.w400S13Grey,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),
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
