import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/medical_special_list.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/custom_elevate_btn.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'widgets/surgery_attachments_widget.dart';

class AddSurgeryView extends StatefulWidget {
  const AddSurgeryView({super.key});

  @override
  State<AddSurgeryView> createState() => _AddSurgeryViewState();
}

class _AddSurgeryViewState extends State<AddSurgeryView> {
  final _formKey = GlobalKey<FormState>();
  final _surgeryNameController = TextEditingController();
  final _surgeryDateController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedSpecialty;

  @override
  void dispose() {
    _surgeryNameController.dispose();
    _surgeryDateController.dispose();
    _diagnosisController.dispose();
    _hospitalController.dispose();
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
        _surgeryDateController.text = DateFormat('MM/dd/yyyy').format(picked);
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.screenBg,
        appBar: AppBar(
          title: Text(
            AppStrings.addSurgery.tr(),
            style: AppStyles.w700S24DarkNavy.copyWith(fontSize: 18.sp),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.screenBg,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20.sp,
              color: AppColors.darkNavyText,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container 1: Basic Surgery Info Card
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.fieldBorder.withValues(alpha: 0.7),
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
                              controller: _surgeryDateController,
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

                  // Container 2: Medical Details Card
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
                        _dropDownButton(),
                        SizedBox(height: 16.h),

                        // Diagnosis / Reason for Procedure
                        CustomTextField(
                          label: AppStrings.diagnosisReasonForProcedure.tr(),
                          hintText: AppStrings.diagnosisReasonHint.tr(),
                          controller: _diagnosisController,
                          maxLines: 3,
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

                  // Container 3: Medical Attachments Card
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
                      onTakePhoto: () {
                        // UI only for now as requested
                      },
                      onChooseFile: () {
                        // UI only for now as requested
                      },
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Save Surgery Record Button
                  CustomElevatedBtn(
                    title: AppStrings.saveSurgeryRecord.tr(),
                    onPressed: () {
                      // UI only, pop back for demonstration
                      Navigator.pop(context);
                    },
                    backgroundColor: AppColors.primaryTeal,
                    height: 52.h,
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

  DropdownButtonFormField<String> _dropDownButton() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedSpecialty,
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
            color: AppColors.fieldBorder,
            width: 1.5,
          ),
        ),
      ),
      items: MedicalSpecialties.specialties.map((specialty) {
        return DropdownMenuItem<String>(
          value: specialty.tr(),
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
