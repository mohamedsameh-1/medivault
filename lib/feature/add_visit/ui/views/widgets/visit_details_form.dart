import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/core/widgets/custom_text_field.dart';
import 'package:medivault/feature/add_visit/ui/viewmodel/visit_details_cubit.dart';
import '../models/specialty_model.dart';
import 'attachment_card_widget.dart';

class VisitDetailsForm extends StatelessWidget {
  final SpecialtyModel specialty;
  final bool isLoading;

  final TextEditingController dateController;
  final TextEditingController doctorNameController;
  final TextEditingController clinicHospitalController;
  final TextEditingController symptomsController;
  final TextEditingController diagnosisController;
  final TextEditingController advisoryNotesController;
  final TextEditingController prescriptionsController;

  final VoidCallback onSelectDate;
  final VisitDetailsCubit cubit;

  final Widget Function(String labelText) buildRequiredLabel;

  const VisitDetailsForm({
    super.key,
    required this.specialty,
    required this.isLoading,
    required this.dateController,
    required this.doctorNameController,
    required this.clinicHospitalController,
    required this.symptomsController,
    required this.diagnosisController,
    required this.advisoryNotesController,
    required this.prescriptionsController,
    required this.onSelectDate,
    required this.cubit,
    required this.buildRequiredLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),

            // Category Header Banner Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.bannerBg,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.badgeGreenBg, width: 1.w),
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      specialty.iconPath,
                      width: 44.r,
                      height: 44.r,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'category'.tr(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryTeal,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        specialty.title.tr(),
                        style: AppStyles.w700S24DarkNavy.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Consultation Information Section Title
            Text(
              'consultation_information'.tr(),
              style: AppStyles.w700S24DarkNavy.copyWith(fontSize: 20.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              'subtitle_of_consultation_information'.tr(),
              style: AppStyles.w400S14Grey.copyWith(
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 16.h),

            // Form Fields Card Container
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: AppColors.fieldBorder, width: 1.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Visit Date
                  GestureDetector(
                    onTap: isLoading ? null : onSelectDate,
                    child: AbsorbPointer(
                      child: CustomTextField(
                        labelWidget: buildRequiredLabel('visit_date'.tr()),
                        hintText: 'select_visit_date'.tr(),
                        controller: dateController,
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Doctor Name
                  CustomTextField(
                    labelWidget: buildRequiredLabel('doctor_name'.tr()),
                    hintText: "enter_the_doctor's_name".tr(),
                    controller: doctorNameController,
                    enabled: !isLoading,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  SizedBox(height: 16.h),

                  // Clinic or Hospital
                  CustomTextField(
                    labelWidget: buildRequiredLabel('clinic_hospital'.tr()),
                    hintText: 'enter_clinic_hospital'.tr(),
                    controller: clinicHospitalController,
                    enabled: !isLoading,
                    prefixIcon: const Icon(Icons.business_outlined),
                  ),
                  SizedBox(height: 16.h),

                  // Reason for Visit / Symptoms
                  CustomTextField(
                    labelWidget: buildRequiredLabel('reason_for_visit'.tr()),
                    hintText: 'enter_reason_for_visit'.tr(),
                    controller: symptomsController,
                    enabled: !isLoading,
                    maxLines: 2,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'describe_symptoms_or_follow_up_goals_discussed_during_consultation'
                        .tr(),
                    style: AppStyles.w400S14Grey.copyWith(
                      fontSize: 11.sp,
                      color: AppColors.secondaryGrey,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Doctor's Diagnosis
                  CustomTextField(
                    labelWidget: buildRequiredLabel("doctor_diagnosis".tr()),
                    hintText: "describe_doctor's_diagnosis_or_clinical_notes"
                        .tr(),
                    controller: diagnosisController,
                    enabled: !isLoading,
                    maxLines: 2,
                  ),
                  SizedBox(height: 10.h),

                  // Disclaimer Box
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: AppColors.bannerBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.bannerBg, width: 1.w),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.strengthBlueText,
                          size: 18.r,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'note_of_doctor_diagonosis'.tr(),
                            style: AppStyles.w400S13Disclaimer.copyWith(
                              fontSize: 11.sp,
                              height: 1.4,
                              color: AppColors.darkNavyText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Doctor's Advisory Notes
                  CustomTextField(
                    label: "doctor's_advisory_notes".tr(),
                    hintText: "enter_advisory_notes".tr(),
                    controller: advisoryNotesController,
                    enabled: !isLoading,
                    maxLines: 2,
                  ),
                  SizedBox(height: 16.h),

                  // Prescriptions & Medication Notes
                  CustomTextField(
                    maxLines: 3,
                    label: 'prescriptions_&_medication_notes'.tr(),
                    hintText: 'enter_prescriptions_&_medications'.tr(),
                    controller: prescriptionsController,
                    enabled: !isLoading,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Medical Attachments Card Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: AppColors.fieldBorder, width: 1.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.medical_services_outlined,
                        color: AppColors.primaryTeal,
                        size: 20.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'medical_attachments'.tr(),
                        style: AppStyles.w700S24DarkNavy.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Action Buttons: Take Photo & Choose File
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : cubit.pickImageFromCamera,
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            size: 18.r,
                            color: AppColors.primaryTeal,
                          ),
                          label: Text(
                            'take_photo'.tr(),
                            style: AppStyles.w600S14PrimaryTeal.copyWith(
                              fontSize: 13.sp,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.bannerBg,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isLoading ? null : cubit.pickFile,
                          icon: Icon(
                            Icons.note_add_outlined,
                            size: 18.r,
                            color: AppColors.primaryTeal,
                          ),
                          label: Text(
                            'choose_file'.tr(),
                            style: AppStyles.w600S14PrimaryTeal.copyWith(
                              fontSize: 13.sp,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.bannerBg,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (cubit.attachments.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cubit.attachments.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final item = cubit.attachments[index];

                        return AttachmentCardWidget(
                          attachment: item,
                          onDelete: isLoading
                              ? () {}
                              : () => cubit.removeAttachment(index),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
