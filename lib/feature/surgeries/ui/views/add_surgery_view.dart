import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/di/di.dart';
import 'package:medivault/core/services/media_picker_service.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/core/utils/medical_special_list.dart';
import 'package:medivault/core/widgets/custom_elevate_btn.dart';
import 'package:medivault/core/widgets/custom_message_dialog.dart';
import 'package:medivault/core/widgets/custom_snack_bar.dart';
import 'package:medivault/core/widgets/custom_text_field.dart';
import 'package:medivault/core/widgets/image_preview_dialog.dart';
import 'package:medivault/core/widgets/media_source_bottom_sheet.dart';
import '../../domain/entities/surgery_attachment_entity.dart';
import '../../domain/entities/surgery_entity.dart';
import '../viewmodel/surgeries_cubit.dart';
import '../viewmodel/surgeries_state.dart';
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
  final _doctorNameController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedSpecialty;
  final List<SurgeryAttachmentEntity> _attachments = [];

  @override
  void dispose() {
    _surgeryNameController.dispose();
    _surgeryDateController.dispose();
    _diagnosisController.dispose();
    _hospitalController.dispose();
    _doctorNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime initial = _selectedDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      locale: context.locale,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _surgeryDateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectImage() async {
    final source = await MediaSourceBottomSheet.show(context);
    if (source == MediaSourceType.camera) {
      await _pickImageFromCamera();
    } else if (source == MediaSourceType.gallery) {
      await _pickImagesFromGallery();
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final mediaPicker = getIt<MediaPickerService>();
      final file = await mediaPicker.pickImageFromCamera();
      if (file != null && mounted) {
        final int size = await file.length();
        final String rawName = file.path.split(RegExp(r'[\\/]')).last;
        final String fileName = rawName.isNotEmpty
            ? rawName
            : 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

        setState(() {
          _attachments.add(
            SurgeryAttachmentEntity(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              fileName: fileName,
              fileType: 'image',
              fileSize: size,
              localPath: file.path,
            ),
          );
        });
      }
    } catch (_) {}
  }

  Future<void> _pickImagesFromGallery() async {
    try {
      final mediaPicker = getIt<MediaPickerService>();
      final files = await mediaPicker.pickImagesFromGallery();
      if (files.isNotEmpty && mounted) {
        for (final file in files) {
          final int size = await file.length();
          final String rawName = file.path.split(RegExp(r'[\\/]')).last;
          final String fileName = rawName.isNotEmpty
              ? rawName
              : 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

          _attachments.add(
            SurgeryAttachmentEntity(
              id: '${DateTime.now().millisecondsSinceEpoch}_${_attachments.length}',
              fileName: fileName,
              fileType: 'image',
              fileSize: size,
              localPath: file.path,
            ),
          );
        }
        setState(() {});
      }
    } catch (_) {}
  }

  void _removeAttachment(int index) {
    if (index >= 0 && index < _attachments.length) {
      setState(() {
        _attachments.removeAt(index);
      });
    }
  }

  void _previewAttachment(SurgeryAttachmentEntity item) {
    if (item.localPath != null && item.localPath!.isNotEmpty) {
      File localFile;
      if (item.localPath!.startsWith('file://')) {
        try {
          localFile = File(Uri.parse(item.localPath!).toFilePath());
        } catch (_) {
          localFile = File(item.localPath!.replaceFirst('file://', ''));
        }
      } else {
        localFile = File(item.localPath!);
      }

      if (localFile.existsSync()) {
        ImagePreviewDialog.show(
          context: context,
          localPath: localFile.path,
          title: item.fileName,
        );
      }
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

  void _submitForm(BuildContext context) {
    if (_surgeryNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          content: AppStrings.addSurgeryName.tr(),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          content: AppStrings.selectSurgeryDate.tr(),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }
    if (_selectedSpecialty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          content: AppStrings.pleaseSelectMedicalSpecialty.tr(),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    final surgery = SurgeryEntity(
      surgeryName: _surgeryNameController.text.trim(),
      specialty: _selectedSpecialty!,
      surgeryDate: _selectedDate!,
      doctorName: _doctorNameController.text.trim(),
      hospitalName: _hospitalController.text.trim(),
      diagnosis: _diagnosisController.text.trim(),
      notes: _notesController.text.trim(),
      attachments: List.from(_attachments),
    );

    context.read<SurgeriesCubit>().addSurgery(surgery);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SurgeriesCubit>(
      create: (context) => getIt<SurgeriesCubit>(),
      child: Builder(
        builder: (context) {
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
              body: BlocConsumer<SurgeriesCubit, SurgeriesState>(
                listener: (context, state) {
                  if (state is AddSurgeryLoadingState) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => CustomMessageDialog(
                        message: AppStrings.loading.tr(),
                        type: MessageType.loading,
                      ),
                    );
                  } else if (state is AddSurgerySuccessState) {
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context).pop(true);
                  } else if (state is AddSurgeryFailureState) {
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
                  final bool isLoading = state is AddSurgeryLoadingState;

                  return SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
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
                                  color: AppColors.fieldBorder.withValues(
                                    alpha: 0.7,
                                  ),
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
                                    enabled: !isLoading,
                                  ),
                                  SizedBox(height: 16.h),

                                  // Surgery Date *
                                  GestureDetector(
                                    onTap: isLoading ? null : _pickDate,
                                    child: AbsorbPointer(
                                      child: CustomTextField(
                                        labelWidget: _buildRequiredLabel(
                                          AppStrings.surgeryDate.tr(),
                                        ),
                                        hintText: 'mm/dd/yyyy'.tr(),
                                        controller: _surgeryDateController,
                                        prefixIcon: Icon(
                                          Icons.calendar_today_outlined,
                                          color: AppColors.iconGrey,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),

                                  // Medical Specialty Dropdown
                                  _buildRequiredLabel(
                                    AppStrings.medicalSpecialty.tr(),
                                  ),
                                  SizedBox(height: 8.h),
                                  _dropDownButton(),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Container 2: Procedure & Hospital Details Card
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
                                  // Surgeon Name
                                  CustomTextField(
                                    label: AppStrings.surgeonName.tr(),
                                    hintText: AppStrings.surgeonNameHint.tr(),
                                    controller: _doctorNameController,
                                    enabled: !isLoading,
                                    prefixIcon: Icon(
                                      Icons.person_outline,
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
                                    enabled: !isLoading,
                                    maxLines: 3,
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
                                    enabled: !isLoading,
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
                                    enabled: !isLoading,
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
                                  color: AppColors.fieldBorder.withValues(
                                    alpha: 0.7,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: SurgeryAttachmentsWidget(
                                attachments: _attachments,
                                isLoading: isLoading,
                                onSelectImage: _selectImage,
                                onRemove: _removeAttachment,
                                onPreview: _previewAttachment,
                              ),
                            ),
                            SizedBox(height: 24.h),

                            // Save Surgery Record Button
                            CustomElevatedBtn(
                              title: AppStrings.saveSurgeryRecord.tr(),
                              onPressed: isLoading
                                  ? () {}
                                  : () => _submitForm(context),
                              backgroundColor: AppColors.primaryTeal,
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
      items: MedicalSpecialties.specialtiesFilteration
          .where((id) => id != 'All')
          .map((id) {
            return DropdownMenuItem<String>(
              value: id,
              child: Text(
                MedicalSpecialties.getSpecialtyTitle(id),
                style: AppStyles.w600S14DarkNavy,
              ),
            );
          })
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedSpecialty = value;
        });
      },
    );
  }
}
