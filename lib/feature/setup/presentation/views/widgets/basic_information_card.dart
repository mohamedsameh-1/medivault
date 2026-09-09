import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_styles.dart';

import 'date_of_birth_field.dart';
import 'gender_selector.dart';
import 'measurement_field.dart';

class BasicInformationCard extends StatelessWidget {
  final String formattedDate;
  final VoidCallback onDateTap;

  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  // final String selectedBloodType;
  // final ValueChanged<String> onBloodTypeChanged;

  final TextEditingController heightController;
  final TextEditingController weightController;

  const BasicInformationCard({
    super.key,
    required this.formattedDate,
    required this.onDateTap,
    required this.selectedGender,
    required this.onGenderChanged,
    // required this.selectedBloodType,
    // required this.onBloodTypeChanged,
    required this.heightController,
    required this.weightController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(19.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(),

          SizedBox(height: 22.h),

          _buildFieldLabel('setup.date_of_birth'.tr()),

          SizedBox(height: 5.h),

          DateOfBirthField(date: formattedDate, onTap: onDateTap),

          SizedBox(height: 22.h),

          _buildFieldLabel('setup.gender_identity'.tr()),

          SizedBox(height: 7.h),

          GenderSelector(
            selectedGender: selectedGender,
            onChanged: onGenderChanged,
          ),

          // SizedBox(height: 20.h),

          // _buildFieldLabel('setup.blood_type'.tr()),

          // SizedBox(height: 7.h),

          // BloodTypeSelector(
          //   selectedBloodType: selectedBloodType,
          //   onChanged: onBloodTypeChanged,
          // ),
          SizedBox(height: 22.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MeasurementField(
                  label: 'setup.height'.tr(),
                  controller: heightController,
                  unit: 'cm',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: MeasurementField(
                  label: 'setup.weight'.tr(),
                  controller: weightController,
                  unit: 'kg',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader() {
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: AppColors.primaryTeal,
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: Icon(
            Icons.medical_information_outlined,
            color: AppColors.white,
            size: 19.sp,
          ),
        ),

        SizedBox(width: 9.w),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'setup.basic_information'.tr(),
              style: AppStyles.w600S14DarkNavy.copyWith(fontSize: 17.sp),
            ),
            SizedBox(height: 1.h),
            Text(
              'setup.identify_records'.tr(),
              style: AppStyles.w500S12StrengthGrey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(text, style: AppStyles.w600S13DisclaimerBold);
  }
}
