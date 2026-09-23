import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/core/widgets/custom_elevate_btn.dart';
import 'package:medivault/core/widgets/custom_text_field.dart';
import 'models/attachment_model.dart';
import 'models/specialty_model.dart';
import 'widgets/attachment_card_widget.dart';

class VisitDetailsView extends StatefulWidget {
  final SpecialtyModel? specialty;

  const VisitDetailsView({super.key, this.specialty});

  @override
  State<VisitDetailsView> createState() => _VisitDetailsViewState();
}

class _VisitDetailsViewState extends State<VisitDetailsView> {
  late DateTime _selectedDate;
  late final TextEditingController _dateController;
  late final TextEditingController _doctorNameController;
  late final TextEditingController _clinicHospitalController;
  late final TextEditingController _symptomsController;
  late final TextEditingController _diagnosisController;
  late final TextEditingController _advisoryNotesController;
  late final TextEditingController _prescriptionsController;

  late List<AttachmentModel> _attachments;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(_selectedDate),
    );
    _doctorNameController = TextEditingController();
    _clinicHospitalController = TextEditingController();
    _symptomsController = TextEditingController();
    _diagnosisController = TextEditingController();
    _advisoryNotesController = TextEditingController();
    _prescriptionsController = TextEditingController();

    _attachments = List.from(AttachmentModel.initialSampleAttachments);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: context.locale,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _doctorNameController.dispose();
    _clinicHospitalController.dispose();
    _symptomsController.dispose();
    _diagnosisController.dispose();
    _advisoryNotesController.dispose();
    _prescriptionsController.dispose();
    super.dispose();
  }

  Widget _buildRequiredLabel(String labelText) {
    return RichText(
      text: TextSpan(
        text: labelText,
        style: AppStyles.w600S14DarkNavy.copyWith(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeSpecialty =
        widget.specialty ?? SpecialtyModel.defaultSpecialties.first;

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.darkNavyText,
            size: 20.r,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'visit_details'.tr(),
          style: AppStyles.w600S16White.copyWith(
            color: AppColors.darkNavyText,
            fontSize: 16.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          // Step Progress Bar
          StepProgressBar(),

          SizedBox(height: 12.h),

          // Scrollable Form Content
          Expanded(
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bannerBg,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.badgeGreenBg,
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            activeSpecialty.iconPath,
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
                              activeSpecialty.title.tr(),
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
                      border: Border.all(
                        color: AppColors.fieldBorder,
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Visit Date
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: CustomTextField(
                              labelWidget: _buildRequiredLabel(
                                'visit_date'.tr(),
                              ),
                              hintText: 'select_visit_date'.tr(),
                              controller: _dateController,
                              prefixIcon: const Icon(
                                Icons.calendar_today_outlined,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Doctor Name
                        CustomTextField(
                          labelWidget: _buildRequiredLabel('doctor_name'.tr()),
                          hintText: "enter_the_doctor's_name".tr(),
                          controller: _doctorNameController,
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        SizedBox(height: 16.h),

                        // Clinic or Hospital
                        CustomTextField(
                          labelWidget: _buildRequiredLabel(
                            'clinic_hospital'.tr(),
                          ),
                          hintText: 'enter_clinic_hospital'.tr(),
                          controller: _clinicHospitalController,
                          prefixIcon: const Icon(Icons.business_outlined),
                        ),
                        SizedBox(height: 16.h),

                        // Reason for Visit / Symptoms
                        CustomTextField(
                          labelWidget: _buildRequiredLabel(
                            'reason_for_visit'.tr(),
                          ),
                          hintText: 'enter_reason_for_visit'.tr(),
                          controller: _symptomsController,
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
                          labelWidget: _buildRequiredLabel(
                            "doctor_diagnosis".tr(),
                          ),
                          hintText:
                              "describe_doctor's_diagnosis_or_clinical_notes"
                                  .tr(),
                          controller: _diagnosisController,
                        ),
                        SizedBox(height: 10.h),

                        // Disclaimer Box
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: AppColors.bannerBg,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.bannerBg,
                              width: 1.w,
                            ),
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
                          controller: _advisoryNotesController,
                        ),
                        SizedBox(height: 16.h),

                        // Prescriptions & Medication Notes
                        CustomTextField(
                          label: 'prescriptions_&_medication_notes'.tr(),
                          hintText: 'enter_prescriptions_&_medications'.tr(),
                          controller: _prescriptionsController,
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
                      border: Border.all(
                        color: AppColors.fieldBorder,
                        width: 1.w,
                      ),
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
                                onPressed: () {
                                  // UI action demonstration
                                },
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
                                onPressed: () {
                                  // UI action demonstration
                                },
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
                        SizedBox(height: 16.h),

                        // List of attached files
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _attachments.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            final item = _attachments[index];
                            return AttachmentCardWidget(
                              attachment: item,
                              onDelete: () {
                                setState(() {
                                  _attachments.removeAt(index);
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          // Bottom Action Bar with Save Visit Button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10.r,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: CustomElevatedBtn(
                title: 'save_visit'.tr(),
                onPressed: () {
                  // UI only for now - demonstrate saving feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('visit_details_saved'.tr()),
                      duration: const Duration(seconds: 2),
                      backgroundColor: AppColors.primaryTeal,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StepProgressBar extends StatelessWidget {
  const StepProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'step_2_of_2'.tr(),
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTeal,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: 1.0,
              minHeight: 4.h,
              backgroundColor: AppColors.fieldBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
