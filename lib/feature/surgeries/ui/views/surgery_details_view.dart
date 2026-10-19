import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medivault/core/di/di.dart';
import 'package:medivault/core/services/surgery_direct_share_service.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_routes.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/core/widgets/custom_elevate_btn.dart';
import 'package:medivault/core/widgets/custom_message_dialog.dart';
import 'package:medivault/feature/surgeries/domain/entities/surgery_entity.dart';
import 'package:share_plus/share_plus.dart';
import '../viewmodel/surgeries_cubit.dart';
import '../viewmodel/surgeries_state.dart';
import 'widgets/surgery_details_info_card_widget.dart';

class SurgeryDetailsView extends StatefulWidget {
  final SurgeryEntity? surgery;

  const SurgeryDetailsView({super.key, this.surgery});

  @override
  State<SurgeryDetailsView> createState() => _SurgeryDetailsViewState();
}

class _SurgeryDetailsViewState extends State<SurgeryDetailsView> {
  SurgeryEntity? _currentSurgery;

  @override
  void initState() {
    super.initState();
    _currentSurgery = widget.surgery;
  }

  void _navigateToEdit(BuildContext context) async {
    if (_currentSurgery == null) return;
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.editSurgeryView,
      arguments: _currentSurgery,
    );
    if (result is SurgeryEntity) {
      setState(() {
        _currentSurgery = result;
      });
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Delete Surgery Record',
            style: AppStyles.w700S24DarkNavy.copyWith(fontSize: 18.sp),
          ),
          content: Text(
            'Are you sure you want to delete this surgery record? This action cannot be undone.',
            style: AppStyles.w400S14Grey.copyWith(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                AppStrings.back.tr(),
                style: AppStyles.w600S14DarkNavy,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                final String idToDelete = _currentSurgery?.id ?? '';
                if (idToDelete.isNotEmpty) {
                  context.read<SurgeriesCubit>().deleteSurgery(idToDelete);
                }
              },
              child: Text(
                AppStrings.delete.tr(),
                style: TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String surgeryName = _currentSurgery?.surgeryName ?? '';

    final String dateStr = _currentSurgery != null
        ? DateFormat('MMM dd, yyyy').format(_currentSurgery!.surgeryDate)
        : '';

    final String specialtyStr = _currentSurgery?.specialty ?? '';

    final String doctorName = _currentSurgery?.doctorName ?? '';

    final String hospitalName = _currentSurgery?.hospitalName ?? '';

    final String diagnosis = _currentSurgery?.diagnosis ?? '';

    // final String anesthesia = _currentSurgery?.anesthesiaType ?? '';

    final String notes = _currentSurgery?.notes ?? '';

    return BlocProvider<SurgeriesCubit>(
      create: (context) => getIt<SurgeriesCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
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
                AppStrings.surgeryDetails.tr(),
                style: AppStyles.w700S24DarkNavy.copyWith(fontSize: 18.sp),
              ),
              actions: [
                // Delete Button
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.red,
                    size: 22.r,
                  ),
                  onPressed: () => _confirmDelete(context),
                ),
                // Edit Button in AppBar (Matching HistoryVisitDetailsView)
                Padding(
                  padding: EdgeInsets.only(
                    right: context.locale.languageCode == 'en' ? 16.w : 0,
                    left: context.locale.languageCode == 'ar' ? 16.w : 0,
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () => _navigateToEdit(context),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 14.r,
                              color: AppColors.white,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              AppStrings.edit.tr(),
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: BlocConsumer<SurgeriesCubit, SurgeriesState>(
              listener: (context, state) {
                if (state is DeleteSurgeryLoadingState) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const CustomMessageDialog(
                      message: 'Deleting Surgery...',
                      type: MessageType.loading,
                    ),
                  );
                } else if (state is DeleteSurgerySuccessState) {
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.of(context).pop(true);
                } else if (state is DeleteSurgeryFailureState) {
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
                      vertical: 12.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Section Title: Surgery Information
                        Row(
                          children: [
                            Icon(
                              Icons.medical_information_outlined,
                              size: 20.r,
                              color: AppColors.primaryTeal,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              AppStrings.surgeryInformation.tr(),
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkNavyText,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),

                        // 2. Information Details Card
                        SurgeryDetailsInfoCardWidget(
                          date: dateStr,
                          medicalSpecialty: specialtyStr,
                          surgeryName: surgeryName,
                          surgeonName: doctorName,
                          hospitalName: hospitalName,
                          diagnosis: diagnosis,
                          // anesthesiaType: anesthesia,
                          notes: notes,
                        ),
                        SizedBox(height: 20.h),

                        // 3. button to share surgery
                        CustomElevatedBtn(
                          title: 'Share Surgery'.tr(),
                          prefixIcon: Icon(Icons.share, color: AppColors.white),
                          onPressed: () async {
                            // await getIt<SurgeryDirectShareService>()
                            //     .shareSurgeryAsText(surgery: _currentSurgery!);
                          },
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
