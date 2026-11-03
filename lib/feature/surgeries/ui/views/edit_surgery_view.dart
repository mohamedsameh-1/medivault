import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/config/supabase_config.dart';
import 'package:medivault/core/di/di.dart';
import 'package:medivault/core/services/media_picker_service.dart';
import 'package:medivault/core/services/supabase_storage_service.dart';
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
import 'package:medivault/feature/surgeries/domain/entities/surgery_attachment_entity.dart';
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
  List<SurgeryAttachmentEntity> _attachments = [];

  @override
  void initState() {
    super.initState();
    _initFormData();
  }

  void _initFormData() {
    final surgery = widget.surgery;

    _selectedDate = surgery?.surgeryDate;
    _selectedSpecialty = surgery?.specialty;
    _attachments = List<SurgeryAttachmentEntity>.from(surgery?.attachments ?? []);

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

  Future<void> _previewAttachment(SurgeryAttachmentEntity item) async {
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
        return;
      }
    }

    final storagePathOrUrl = item.fileUrl;
    if (storagePathOrUrl == null || storagePathOrUrl.isEmpty) return;

    if (storagePathOrUrl.startsWith('http://') ||
        storagePathOrUrl.startsWith('https://')) {
      ImagePreviewDialog.show(
        context: context,
        imageUrl: storagePathOrUrl,
        title: item.fileName,
      );
      return;
    }

    // Supabase private storage signed URL
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomMessageDialog(
        message: AppStrings.loading.tr(),
        type: MessageType.loading,
      ),
    );

    try {
      final storageService = getIt<SupabaseStorageService>();
      final signedUrl = await storageService.getSignedUrl(
        bucket: SupabaseConfig.surgeryImagesBucket,
        path: storagePathOrUrl,
      );

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ImagePreviewDialog.show(
          context: context,
          imageUrl: signedUrl,
          title: item.fileName,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            content: e.toString().replaceFirst('Exception: ', ''),
            backgroundColor: AppColors.red,
          ),
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

  void _onSaveChanges(BuildContext context) {
    if (_surgeryNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          content: AppStrings.surgeryNameHint.tr(),
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
      attachments: List.from(_attachments),
    );

    context.read<SurgeriesCubit>().updateSurgery(updated);
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
                      builder: (_) => CustomMessageDialog(
                        message: AppStrings.loading.tr(),
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
                  final bool isLoading = state is EditSurgeryLoadingState;

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
                                    enabled: !isLoading,
                                  ),
                                  SizedBox(height: 16.h),

                                  // Date of Procedure *
                                  GestureDetector(
                                    onTap: isLoading ? null : _pickDate,
                                    child: AbsorbPointer(
                                      child: CustomTextField(
                                        labelWidget: _buildRequiredLabel(
                                          AppStrings.dateOfProcedure.tr(),
                                        ),
                                        hintText: 'mm/dd/yyyy',
                                        controller: _dateController,
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
                                  Text(
                                    AppStrings.medicalSpecialty.tr(),
                                    style: AppStyles.w600S14DarkNavy.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  _buildSpecialtyDropdown(),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Surgical Team & Facility Card
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
                                    controller: _surgeonController,
                                    enabled: !isLoading,
                                    prefixIcon: Icon(
                                      Icons.person_outline,
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
                                    enabled: !isLoading,
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
                                    enabled: !isLoading,
                                    maxLines: 3,
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
                                attachments: _attachments,
                                isLoading: isLoading,
                                onSelectImage: _selectImage,
                                onRemove: _removeAttachment,
                                onPreview: _previewAttachment,
                              ),
                            ),
                            SizedBox(height: 24.h),

                            // Bottom Action Buttons: Save Changes
                            CustomElevatedBtn(
                              title: AppStrings.saveChanges.tr(),
                              backgroundColor: AppColors.primaryTeal,
                              onPressed: isLoading
                                  ? () {}
                                  : () => _onSaveChanges(context),
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
      initialValue: currentSelection,
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
