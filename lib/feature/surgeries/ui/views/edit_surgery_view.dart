import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medivault/core/di/di.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/core/utils/medical_special_list.dart';
import 'package:medivault/core/widgets/custom_elevate_btn.dart';
import 'package:medivault/core/widgets/custom_message_dialog.dart';
import 'package:medivault/core/widgets/custom_text_field.dart';
import 'package:medivault/feature/surgeries/domain/entities/surgery_entity.dart';
import 'package:medivault/feature/surgeries/ui/views/widgets/surgery_attachments_widget.dart';

import '../viewmodel/surgeries_cubit.dart';
import '../viewmodel/surgeries_state.dart';

class EditSurgeryView extends StatefulWidget {
  final SurgeryEntity? surgery;

  const EditSurgeryView({super.key, this.surgery});

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
  late final TextEditingController _notesController;

  DateTime? _selectedDate;
  String? _selectedSpecialty;
  List<String> _attachments = [];

  @override
  void initState() {
    super.initState();
    _initFormData();
  }

  void _initFormData() {
    final surgery = widget.surgery;

    _selectedDate = surgery?.surgeryDate;
    _selectedSpecialty = surgery?.specialty;
    _attachments = List<String>.from(surgery?.attachments ?? []);

    _surgeryNameController = TextEditingController(
      text: surgery?.surgeryName ?? '',
    );
    _dateController = TextEditingController(
      text: surgery != null
          ? DateFormat('MM/dd/yyyy').format(surgery.surgeryDate)
          : '',
    );
    _diagnosisController = TextEditingController(
      text: surgery?.diagnosis ?? '',
    );
    _hospitalController = TextEditingController(
      text: surgery?.hospitalName ?? '',
    );
    _surgeonController = TextEditingController(text: surgery?.doctorName ?? '');
    _notesController = TextEditingController(text: surgery?.notes ?? '');
  }

  @override
  void dispose() {
    _surgeryNameController.dispose();
    _dateController.dispose();
    _diagnosisController.dispose();
    _hospitalController.dispose();
    _surgeonController.dispose();
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

  Future<void> _takePhoto() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _attachments.add(image.path);
        });
      }
    } catch (_) {}
  }

  Future<void> _chooseFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        setState(() {
          _attachments.add(result.files.single.path!);
        });
      }
    } catch (_) {}
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

  void _onSaveChanges(BuildContext context) {
    if (_surgeryNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.surgeryNameHint.tr()),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    final String surgeryId = widget.surgery?.id ?? '';

    final updated = SurgeryEntity(
      id: surgeryId,
      surgeryName: _surgeryNameController.text.trim(),
      specialty: _selectedSpecialty ?? 'others',
      surgeryDate: _selectedDate ?? DateTime.now(),
      doctorName: _surgeonController.text.trim(),
      hospitalName: _hospitalController.text.trim(),
      diagnosis: _diagnosisController.text.trim(),
      notes: _notesController.text.trim(),
      attachments: _attachments,
    );

    context.read<SurgeriesCubit>().updateSurgery(updated);
  }

  @override
  Widget build(BuildContext context) {
    // final String currentSpecialtyTitle = MedicalSpecialties.getSpecialtyTitle(
    //   _selectedSpecialty ?? 'surgeries',
    // );

    return BlocProvider<SurgeriesCubit>(
      create: (context) => getIt<SurgeriesCubit>(),
      child: Builder(
        builder: (context) {
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
              body: BlocConsumer<SurgeriesCubit, SurgeriesState>(
                listener: (context, state) {
                  if (state is EditSurgeryLoadingState) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const CustomMessageDialog(
                        message: 'Saving Changes...',
                        type: MessageType.loading,
                      ),
                    );
                  } else if (state is EditSurgerySuccessState) {
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context).pop(state.updatedSurgery);
                  } else if (state is EditSurgeryFailureState) {
                    Navigator.of(context, rootNavigator: true).pop();
                    showDialog(
                      context: context,
                      builder: (_) => CustomMessageDialog(
                        message: state.failure.failureMessage.tr(),
                        type: MessageType.error,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return SafeArea(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Basic Surgery Info Card
                            Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: AppColors.fieldBorder.withValues(
                                    alpha: 0.7,
                                  ),
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
                                  color: AppColors.fieldBorder.withValues(
                                    alpha: 0.7,
                                  ),
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
                                    label: AppStrings.hospitalSurgicalCenter
                                        .tr(),
                                    hintText: AppStrings
                                        .hospitalSurgicalCenterHint
                                        .tr(),
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
                                    label: AppStrings
                                        .diagnosisReasonForProcedure
                                        .tr(),
                                    hintText: AppStrings.diagnosisReasonHint
                                        .tr(),
                                    controller: _diagnosisController,
                                    maxLines: 3,
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
                                  color: AppColors.fieldBorder.withValues(
                                    alpha: 0.7,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: SurgeryAttachmentsWidget(
                                onTakePhoto: _takePhoto,
                                onChooseFile: _chooseFile,
                              ),
                            ),
                            SizedBox(height: 24.h),

                            // Bottom Action Buttons: Back & Save Changes
                            CustomElevatedBtn(
                              title: AppStrings.saveChanges.tr(),
                              backgroundColor: AppColors.primaryTeal,
                              onPressed: () => _onSaveChanges(context),
                              height: 52.h,
                            ),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpecialtyDropdown() {
    final items = MedicalSpecialties.specialtiesFilteration
        .where((id) => id != 'All')
        .toList();

    final String? currentSelection = items.contains(_selectedSpecialty)
        ? _selectedSpecialty
        : null;

    return DropdownButtonFormField<String>(
      value: currentSelection,
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
      items: items.map((id) {
        return DropdownMenuItem<String>(
          value: id,
          child: Text(
            MedicalSpecialties.getSpecialtyTitle(id),
            style: AppStyles.w600S14DarkNavy,
          ),
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
