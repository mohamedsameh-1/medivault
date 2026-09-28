import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/core/utils/medical_special_list.dart';
import 'package:medivault/core/widgets/custom_elevate_btn.dart';
import 'package:medivault/core/widgets/custom_text_field.dart';
import 'package:medivault/feature/surgeries/domain/entities/surgery_entity.dart';
import 'package:medivault/feature/surgeries/ui/views/widgets/surgery_attachments_widget.dart';

class EditSurgeryView extends StatefulWidget {
  final SurgeryEntity? surgery;
  final Map<String, dynamic>? surgeryData;

  const EditSurgeryView({super.key, this.surgery, this.surgeryData});

  @override
  State<EditSurgeryView> createState() => _EditSurgeryViewState();
}

class _EditSurgeryViewState extends State<EditSurgeryView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _surgeryNameController;
  late final TextEditingController _dateController;
  late final TextEditingController _diagnosisController;
  late final TextEditingController _hospitalController;
  late final TextEditingController _surgeonController;
  late final TextEditingController _anesthesiaController;
  late final TextEditingController _notesController;

  DateTime? _selectedDate;
  String? _selectedSpecialty;

  @override
  void initState() {
    super.initState();

    final surgery = widget.surgery;
    final data = widget.surgeryData ?? {};

    String nameStr = '';
    String dateStr = '';
    String specialtyStr = '';
    String diagnosisStr = '';
    String hospitalStr = '';
    String surgeonStr = '';
    String anesthesiaStr = '';
    String notesStr = '';

    if (surgery != null) {
      nameStr = surgery.surgeryName;
      _selectedDate = surgery.surgeryDate;
      dateStr = DateFormat('MM/dd/yyyy').format(surgery.surgeryDate);
      specialtyStr = surgery.specialty;
      diagnosisStr = surgery.diagnosis ?? '';
      hospitalStr = surgery.hospitalName;
      surgeonStr = surgery.doctorName;
      anesthesiaStr = surgery.anesthesiaType ?? '';
      notesStr = surgery.notes ?? '';
    } else if (data.isNotEmpty) {
      nameStr = data['surgeryName'] ?? '';
      dateStr = data['date'] ?? DateFormat('MM/dd/yyyy').format(DateTime.now());
      specialtyStr = data['specialty'] ?? '';
      diagnosisStr = data['diagnosis'] ?? '';
      hospitalStr = data['hospitalName'] ?? '';
      surgeonStr = data['doctorName'] ?? '';
      anesthesiaStr = data['anesthesiaType'] ?? '';
      notesStr = data['notes'] ?? '';
    } else {
      // Default fallback mock values for preview
      nameStr = 'ACL Reconstruction';
      _selectedDate = DateTime(2026, 9, 12);
      dateStr = DateFormat('MM/dd/yyyy').format(_selectedDate!);
      specialtyStr = 'Orthopedics';
      diagnosisStr = 'Torn Anterior Cruciate Ligament';
      hospitalStr = 'ABC Hospital';
      surgeonStr = 'Dr. Ahmed Mohamed';
      anesthesiaStr = 'General Anesthesia';
      notesStr = 'Patient requires post-op physical therapy for 6 weeks.';
    }

    _surgeryNameController = TextEditingController(text: nameStr);
    _dateController = TextEditingController(text: dateStr);
    _diagnosisController = TextEditingController(text: diagnosisStr);
    _hospitalController = TextEditingController(text: hospitalStr);
    _surgeonController = TextEditingController(text: surgeonStr);
    _anesthesiaController = TextEditingController(text: anesthesiaStr);
    _notesController = TextEditingController(text: notesStr);
    _selectedSpecialty = specialtyStr.isNotEmpty ? specialtyStr : null;
  }

  @override
  void dispose() {
    _surgeryNameController.dispose();
    _dateController.dispose();
    _diagnosisController.dispose();
    _hospitalController.dispose();
    _surgeonController.dispose();
    _anesthesiaController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime initial = _selectedDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      locale: context.locale,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  Widget _buildRequiredLabel(String labelText) {
    return RichText(
      text: TextSpan(
        text: labelText,
        style: AppStyles.w600S14DarkNavy.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        children: [
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
    final String currentSpecialty = _selectedSpecialty ?? 'Surgery';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.screenBg,
        appBar: AppBar(
          backgroundColor: AppColors.screenBg,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.darkNavyText,
              size: 20.r,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            AppStrings.editSurgeryForm.tr(),
            style: AppStyles.w700S24DarkNavy.copyWith(fontSize: 18.sp),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Banner: Specialty & Edit indicator (Matching EditVisitView)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: AppColors.bannerBg,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: AppColors.lightBlueButton,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                                currentSpecialty,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              AppStrings.edit.tr(),
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkNavyText,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          AppStrings.editSurgeryBannerDesc.tr(),
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryGrey,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Basic Surgery Info Card
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.fieldBorder.withValues(alpha: 0.7),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Surgery Name *
                        CustomTextField(
                          labelWidget: _buildRequiredLabel(
                            AppStrings.surgeryName.tr(),
                          ),
                          hintText: AppStrings.surgeryNameHint.tr(),
                          controller: _surgeryNameController,
                        ),
                        SizedBox(height: 16.h),

                        // Surgery Date *
                        GestureDetector(
                          onTap: _pickDate,
                          child: AbsorbPointer(
                            child: CustomTextField(
                              labelWidget: _buildRequiredLabel(
                                AppStrings.surgeryDate.tr(),
                              ),
                              hintText: 'mm/dd/yyyy',
                              controller: _dateController,
                              suffixIcon: Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.iconGrey,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Medical Details Card
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.fieldBorder.withValues(alpha: 0.7),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Medical Specialty Dropdown
                        Text(
                          AppStrings.medicalSpecialty.tr(),
                          style: AppStyles.w600S14DarkNavy.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        _buildSpecialtyDropdown(),
                        SizedBox(height: 16.h),

                        // Surgeon Name
                        CustomTextField(
                          label: AppStrings.surgeonName.tr(),
                          hintText: AppStrings.surgeonNameHint.tr(),
                          controller: _surgeonController,
                          prefixIcon: Icon(
                            Icons.person_outline_rounded,
                            color: AppColors.iconGrey,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Hospital / Surgical Center
                        CustomTextField(
                          label: AppStrings.hospitalSurgicalCenter.tr(),
                          hintText: AppStrings.hospitalSurgicalCenterHint.tr(),
                          controller: _hospitalController,
                          prefixIcon: Icon(
                            Icons.local_hospital_outlined,
                            color: AppColors.iconGrey,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Diagnosis / Reason for Procedure
                        CustomTextField(
                          label: AppStrings.diagnosisReasonForProcedure.tr(),
                          hintText: AppStrings.diagnosisReasonHint.tr(),
                          controller: _diagnosisController,
                          maxLines: 3,
                        ),
                        SizedBox(height: 16.h),

                        // Anesthesia Type
                        CustomTextField(
                          label: AppStrings.anesthesiaType.tr(),
                          hintText: AppStrings.anesthesiaTypeHint.tr(),
                          controller: _anesthesiaController,
                          prefixIcon: Icon(
                            Icons.medical_services_outlined,
                            color: AppColors.iconGrey,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Notes
                        CustomTextField(
                          label: AppStrings.notes.tr(),
                          hintText: AppStrings.notesHint.tr(),
                          controller: _notesController,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Medical Attachments Card
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.fieldBorder.withValues(alpha: 0.7),
                        width: 1,
                      ),
                    ),
                    child: SurgeryAttachmentsWidget(
                      onTakePhoto: () {},
                      onChooseFile: () {},
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Bottom Action Buttons: Back & Save Changes
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedBtn(
                          title: AppStrings.back.tr(),
                          backgroundColor: AppColors.lightBlueButton,
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkNavyText,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          height: 52.h,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomElevatedBtn(
                          title: AppStrings.saveChanges.tr(),
                          backgroundColor: AppColors.primaryTeal,
                          onPressed: () {
                            // UI-only for now as requested
                            Navigator.of(context).pop();
                          },
                          height: 52.h,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialtyDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedSpecialty,
      menuMaxHeight: 300.h,
      decoration: InputDecoration(
        hintText: AppStrings.selectSurgicalSpecialty.tr(),
        hintStyle: AppStyles.w400S14Hint,
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: AppColors.fieldBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(
            color: AppColors.primaryTeal,
            width: 1.5,
          ),
        ),
      ),
      items: MedicalSpecialties.specialties.map((specialty) {
        return DropdownMenuItem<String>(
          value: specialty,
          child: Text(specialty.tr(), style: AppStyles.w600S14DarkNavy),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedSpecialty = value;
        });
      },
    );
  }
}
