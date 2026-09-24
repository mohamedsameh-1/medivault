import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/di/di.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_routes.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/core/widgets/custom_elevate_btn.dart';
import 'package:medivault/feature/add_visit/ui/views/widgets/step_progress_bar.dart';
import 'package:medivault/feature/add_visit/ui/views/widgets/visit_details_form.dart';
import '../viewmodel/visit_details_cubit.dart';
import '../viewmodel/visit_details_state.dart';
import 'models/specialty_model.dart';

class VisitDetailsView extends StatelessWidget {
  final SpecialtyModel? specialty;

  const VisitDetailsView({super.key, this.specialty});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VisitDetailsCubit>(),
      child: _VisitDetailsContent(specialty: specialty),
    );
  }
}

class _VisitDetailsContent extends StatefulWidget {
  final SpecialtyModel? specialty;

  const _VisitDetailsContent({this.specialty});

  @override
  State<_VisitDetailsContent> createState() => _VisitDetailsContentState();
}

class _VisitDetailsContentState extends State<_VisitDetailsContent> {
  late DateTime _selectedDate;
  late final TextEditingController _dateController;
  late final TextEditingController _doctorNameController;
  late final TextEditingController _clinicHospitalController;
  late final TextEditingController _symptomsController;
  late final TextEditingController _diagnosisController;
  late final TextEditingController _advisoryNotesController;
  late final TextEditingController _prescriptionsController;

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
    final cubit = context.read<VisitDetailsCubit>();

    return BlocConsumer<VisitDetailsCubit, VisitDetailsState>(
      listener: (context, state) {
        if (state is VisitDetailsValidationFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.messageKey.tr()),
              backgroundColor: AppColors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is VisitDetailsFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.failureMessage.tr()),
              backgroundColor: AppColors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is VisitDetailsSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('visit_details_saved'.tr()),
              backgroundColor: AppColors.primaryTeal,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.navigationView, (route) => false);
        }
      },
      builder: (context, state) {
        final bool isLoading = state is VisitDetailsLoadingState;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
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
                onPressed: isLoading ? null : () => Navigator.of(context).pop(),
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
                const StepProgressBar(),
                SizedBox(height: 12.h),

                // Scrollable Form Content
                VisitDetailsForm(
                  specialty: activeSpecialty,
                  isLoading: isLoading,
                  dateController: _dateController,
                  doctorNameController: _doctorNameController,
                  clinicHospitalController: _clinicHospitalController,
                  symptomsController: _symptomsController,
                  diagnosisController: _diagnosisController,
                  advisoryNotesController: _advisoryNotesController,
                  prescriptionsController: _prescriptionsController,
                  onSelectDate: () => _selectDate(context),
                  cubit: cubit,
                  buildRequiredLabel: _buildRequiredLabel,
                ),
                // Bottom Action Bar with Save Visit Button
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
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
                      prefixIcon: isLoading
                          ? SizedBox(
                              width: 20.r,
                              height: 20.r,
                              child: const CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : null,
                      onPressed: isLoading
                          ? () {}
                          : () {
                              cubit.saveVisit(
                                specialtyId: activeSpecialty.id,
                                visitDate: _selectedDate,
                                doctorName: _doctorNameController.text,
                                clinicHospital: _clinicHospitalController.text,
                                symptoms: _symptomsController.text,
                                diagnosis: _diagnosisController.text,
                                advisoryNotes: _advisoryNotesController.text,
                                prescriptions: _prescriptionsController.text,
                              );
                            },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
