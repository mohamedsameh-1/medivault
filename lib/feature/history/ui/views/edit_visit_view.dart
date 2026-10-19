import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medivault/core/di/di.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/core/utils/app_validator.dart';
import 'package:medivault/core/widgets/custom_elevate_btn.dart';
import 'package:medivault/core/widgets/custom_text_field.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_attachment_entity.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';
import 'package:medivault/feature/add_visit/ui/views/models/specialty_model.dart';
import 'package:medivault/feature/history/ui/viewmodel/history_cubit.dart';
import 'package:medivault/feature/history/ui/viewmodel/history_state.dart';
import 'package:medivault/feature/history/ui/views/widgets/visit_attachment_tile_widget.dart';

class EditVisitView extends StatefulWidget {
  final SpecialtyModel? specialty;
  final Map<String, dynamic>? visitData;

  const EditVisitView({super.key, this.specialty, this.visitData});

  @override
  State<EditVisitView> createState() => _EditVisitViewState();
}

class _EditVisitViewState extends State<EditVisitView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _dateController;
  late final TextEditingController _doctorController;
  late final TextEditingController _clinicController;
  late final TextEditingController _reasonController;
  late final TextEditingController _diagnosisController;
  late final TextEditingController _advisoryController;
  late final TextEditingController _prescriptionController;

  late List<VisitAttachmentEntity> _attachments;
  VisitEntity? _lastUpdatedVisit;

  @override
  void initState() {
    super.initState();
    final data = widget.visitData ?? {};

    final visitObj = data['visit'];
    String dateStr = '';
    String doctorStr = '';
    String clinicStr = '';
    String reasonStr = '';
    String diagnosisStr = '';
    String advisoryStr = '';
    String prescriptionStr = '';

    if (visitObj is VisitEntity) {
      dateStr = DateFormat('MMM dd, yyyy').format(visitObj.visitDate);
      doctorStr = visitObj.doctorName;
      clinicStr = visitObj.clinicHospital;
      reasonStr = visitObj.symptoms;
      diagnosisStr = visitObj.diagnosis;
      advisoryStr = visitObj.advisoryNotes ?? '';
      prescriptionStr = visitObj.prescriptions ?? '';
      _attachments = List.from(visitObj.attachments);
    } else if (data.isNotEmpty) {
      dateStr =
          data['date'] ?? DateFormat('MMM dd, yyyy').format(DateTime.now());
      doctorStr = data['doctorName'] ?? '';
      clinicStr = data['clinicName'] ?? '';
      reasonStr = data['reasonForVisit'] ?? '';
      diagnosisStr = data['diagnosis'] ?? '';
      advisoryStr = data['advisoryNotes'] ?? '';
      prescriptionStr = data['prescriptions'] ?? '';
      _attachments = [];
    } else {
      dateStr = DateFormat('MMM dd, yyyy').format(DateTime.now());
      _attachments = [];
    }

    _dateController = TextEditingController(text: dateStr);
    _doctorController = TextEditingController(text: doctorStr);
    _clinicController = TextEditingController(text: clinicStr);
    _reasonController = TextEditingController(text: reasonStr);
    _diagnosisController = TextEditingController(text: diagnosisStr);
    _advisoryController = TextEditingController(text: advisoryStr);
    _prescriptionController = TextEditingController(text: prescriptionStr);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _doctorController.dispose();
    _clinicController.dispose();
    _reasonController.dispose();
    _diagnosisController.dispose();
    _advisoryController.dispose();
    _prescriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        final int size = await file.length();
        final String fileName = pickedFile.name.isNotEmpty
            ? pickedFile.name
            : 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

        setState(() {
          _attachments.add(
            VisitAttachmentEntity(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              fileName: fileName,
              fileType: 'image',
              fileSize: size,
              localPath: pickedFile.path,
            ),
          );
        });
      }
    } catch (e) {
      // Ignore picker error
    }
  }

  Future<void> _pickFile() async {
    try {
      final dynamic picker = FilePicker.platform;
      final dynamic result = await picker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );

      if (result != null &&
          result.files != null &&
          (result.files as List).isNotEmpty) {
        final dynamic platformFile = (result.files as List).first;
        final String path = platformFile.path?.toString() ?? '';

        if (path.isNotEmpty) {
          final File file = File(path);
          final int size = await file.exists() ? await file.length() : 0;
          final String ext =
              platformFile.extension?.toString().toLowerCase() ?? '';
          final isPdf = ext == 'pdf';

          setState(() {
            _attachments.add(
              VisitAttachmentEntity(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                fileName: platformFile.name?.toString() ?? 'file',
                fileType: isPdf ? 'pdf' : 'image',
                fileSize: size,
                localPath: path,
              ),
            );
          });
        }
      }
    } catch (e) {
      // Ignore picker error
    }
  }

  @override
  Widget build(BuildContext context) {
    final specialtyTitle = widget.specialty?.title.tr() ?? '';

    return BlocProvider(
      create: (context) => getIt<HistoryCubit>(),
      child: BlocConsumer<HistoryCubit, HistoryState>(
        listener: (context, state) {
          if (state is UpdateVisitSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppStrings.visitUpdatedSuccessfully.tr())),
            );
            Navigator.of(context).pop(_lastUpdatedVisit);
          } else if (state is HistoryFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.failure.failureMessage)),
            );
          }
        },
        builder: (context, state) {
          final isUpdating = state is UpdateVisitLoadingState;

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
                    Icons.arrow_back_ios_new,
                    color: AppColors.darkNavyText,
                    size: 20.r,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  AppStrings.editVisitForm.tr(),
                  style: AppStyles.w700S24DarkNavy.copyWith(fontSize: 18.sp),
                ),
              ),
              body: SafeArea(
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
                        // Top Banner: Specialty sync indicator
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
                                  if (widget.specialty != null) ...[
                                    Container(
                                      width: 24.r,
                                      height: 24.r,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFEE2E2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          height: double.infinity,
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                          widget.specialty!.iconPath,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                  ],
                                  Text(
                                    specialtyTitle,
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
                                AppStrings.editVisitBannerDesc.tr(),
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

                        // Visit Date
                        CustomTextField(
                          enabled: false,
                          controller: _dateController,
                          labelWidget: _buildRequiredLabel(
                            AppStrings.visitDate.tr(),
                          ),
                          hintText: AppStrings.selectVisitDate.tr(),
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                        ),
                        SizedBox(height: 16.h),

                        // Doctor Name
                        CustomTextField(
                          controller: _doctorController,
                          labelWidget: _buildRequiredLabel(
                            AppStrings.doctorName.tr(),
                          ),
                          hintText: AppStrings.enterTheDoctorsName.tr(),
                          validator: (value) => AppValidator.validateRequired(
                            value,
                            AppStrings.doctorNameRequired.tr(),
                          ),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        SizedBox(height: 16.h),

                        // Clinic or Hospital
                        CustomTextField(
                          controller: _clinicController,
                          labelWidget: _buildRequiredLabel(
                            AppStrings.clinicHospital.tr(),
                          ),
                          hintText: AppStrings.enterClinicHospital.tr(),
                          validator: (value) => AppValidator.validateRequired(
                            value,
                            AppStrings.clinicHospitalRequired.tr(),
                          ),
                          prefixIcon: const Icon(
                            Icons.add_location_alt_outlined,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Reason for Visit / Symptoms
                        CustomTextField(
                          controller: _reasonController,
                          labelWidget: _buildRequiredLabel(
                            AppStrings.symptoms.tr(),
                          ),
                          hintText: AppStrings
                              .describeSymptomsOrFollowUpGoalsDiscussedDuringConsultation
                              .tr(),
                          validator: (value) => AppValidator.validateRequired(
                            value,
                            AppStrings.symptomsRequired.tr(),
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(height: 16.h),

                        // Doctor's Diagnosis
                        CustomTextField(
                          controller: _diagnosisController,
                          labelWidget: _buildRequiredLabel(
                            AppStrings.doctorDiagnosis.tr(),
                          ),
                          hintText: AppStrings.enterDiagnosis.tr(),
                          validator: (value) => AppValidator.validateRequired(
                            value,
                            AppStrings.diagnosisRequired.tr(),
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(height: 16.h),

                        // Doctor's Advisory Notes
                        CustomTextField(
                          controller: _advisoryController,
                          label: AppStrings.advisoryNotes.tr(),
                          hintText: AppStrings.enterAdvisoryNotes.tr(),
                          maxLines: 3,
                        ),
                        SizedBox(height: 16.h),

                        // Prescriptions & Dosages
                        CustomTextField(
                          controller: _prescriptionController,
                          label: AppStrings.prescriptions.tr(),
                          hintText: AppStrings.enterPrescriptionsMedications
                              .tr(),
                          prefixIcon: const Icon(Icons.local_pharmacy_outlined),
                          maxLines: 2,
                        ),
                        SizedBox(height: 24.h),

                        // Medical Attachments
                        Text(
                          AppStrings.medicalAttachments.tr(),
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkNavyText,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Upload Action Buttons Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildAttachmentButton(
                                icon: Icons.camera_alt_outlined,
                                label: AppStrings.takePhoto.tr(),
                                onTap: _pickImageFromCamera,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildAttachmentButton(
                                icon: Icons.note_add_outlined,
                                label: AppStrings.chooseFile.tr(),
                                onTap: _pickFile,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Attachments List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _attachments.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            final item = _attachments[index];
                            final isImage =
                                item.fileType == 'image' ||
                                item.fileName.endsWith('.jpg') ||
                                item.fileName.endsWith('.png');
                            final fileSizeText = item.fileSize != null
                                ? '${(item.fileSize! / 1024).toStringAsFixed(1)} KB'
                                : (isImage ? 'Image File' : 'PDF Document');

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == _attachments.length - 1
                                    ? 0
                                    : 10.h,
                              ),
                              child: VisitAttachmentTileWidget(
                                name: item.fileName,
                                type: fileSizeText,
                                isImage: isImage,
                                onDelete: () {
                                  setState(() {
                                    _attachments.removeAt(index);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 30.h),

                        // Bottom Actions: Cancel & Save Changes
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
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: CustomElevatedBtn(
                                title: isUpdating
                                    ? AppStrings.saving.tr()
                                    : AppStrings.saveChanges.tr(),
                                backgroundColor: AppColors.primaryTeal,
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                                onPressed: isUpdating
                                    ? () {}
                                    : () {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }

                                        final data = widget.visitData ?? {};
                                        final visitObj = data['visit'];
                                        String visitId = '';
                                        DateTime date = DateTime.now();
                                        DateTime? createdAt = DateTime.now();

                                        if (visitObj is VisitEntity) {
                                          visitId = visitObj.id ?? '';
                                          date = visitObj.visitDate;
                                          createdAt = visitObj.createdAt;
                                        } else if (data.containsKey('id')) {
                                          visitId = data['id'] ?? '';
                                        }

                                        final updatedVisit = VisitEntity(
                                          id: visitId,
                                          specialtyId:
                                              widget.specialty?.id ??
                                              (visitObj is VisitEntity
                                                  ? visitObj.specialtyId
                                                  : 'cardiology'),
                                          visitDate: date,
                                          doctorName: _doctorController.text
                                              .trim(),
                                          clinicHospital: _clinicController.text
                                              .trim(),
                                          symptoms: _reasonController.text
                                              .trim(),
                                          diagnosis: _diagnosisController.text
                                              .trim(),
                                          advisoryNotes: _advisoryController
                                              .text
                                              .trim(),
                                          prescriptions: _prescriptionController
                                              .text
                                              .trim(),
                                          createdAt: createdAt,
                                          attachments: List.from(_attachments),
                                        );

                                        _lastUpdatedVisit = updatedVisit;

                                        context
                                            .read<HistoryCubit>()
                                            .updateVisitRecord(updatedVisit);
                                      },
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
        },
      ),
    );
  }

  Widget _buildRequiredLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: AppStyles.w600S14DarkNavy,
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: AppColors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 46.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18.r, color: AppColors.primaryTeal),
            SizedBox(width: 6.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTeal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
