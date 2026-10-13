import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/core/utils/medical_special_list.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';

class HomeDoctorVisitCardWidget extends StatelessWidget {
  final VisitEntity visit;
  final VoidCallback? onTap;

  const HomeDoctorVisitCardWidget({super.key, required this.visit, this.onTap});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'dd MMM yyyy',
    ).format(visit.visitDate);

    final String specialtyTitle = MedicalSpecialties.getSpecialtyTitle(
      visit.specialtyId,
    ).toUpperCase();

    return Container(
      width: double.infinity,
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
              Container(
                width: 5.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal,
                  borderRadius: BorderRadius.circular(16.r),
                ),
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
                        // Top Row: SPECIALTY CONSULTATION (Teal uppercase) + Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              specialtyTitle,
                              style: AppStyles.w700S11PrimaryTeal,
                            ),
                            Text(formattedDate, style: AppStyles.w500S12Grey),
                          ],
                        ),

                        SizedBox(height: 8.h),

                        // Doctor Name (Prominent bold text)
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline_rounded,
                              size: 16.sp,
                              color: AppColors.darkNavyText,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              visit.doctorName,
                              style: AppStyles.w700S16DarkNavy,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18.sp,
                              color: AppColors.iconGrey,
                            ),
                          ],
                        ),

                        SizedBox(height: 4.h),

                        // Clinic / Hospital
                        Row(
                          children: [
                            Icon(
                              Icons.local_hospital_outlined,
                              size: 16.sp,
                              color: AppColors.iconGrey,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              visit.clinicHospital,
                              style: AppStyles.w400S13Grey,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
