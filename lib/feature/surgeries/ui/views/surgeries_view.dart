import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/medical_special_list.dart';
import 'package:medivault/core/widgets/app_brand_header.dart';
import 'package:medivault/core/widgets/custom_gradient_header.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/custom_elevate_btn.dart';
import '../../data/model/surgery_model.dart';
import 'widgets/specialty_filter_chips_widget.dart';
import 'widgets/surgery_card_widget.dart';
import 'widgets/surgery_empty_state_widget.dart';

class SurgeriesView extends StatefulWidget {
  const SurgeriesView({super.key});

  @override
  State<SurgeriesView> createState() => _SurgeriesViewState();
}

class _SurgeriesViewState extends State<SurgeriesView> {
  String _selectedSpecialty = 'All';
  List<SurgeryModel> _surgeries = List.from(SurgeryModel.dummySurgeries);

  List<SurgeryModel> get _filteredSurgeries {
    if (_selectedSpecialty == 'All') {
      return _surgeries;
    }
    return _surgeries
        .where(
          (s) => s.specialty.toLowerCase() == _selectedSpecialty.toLowerCase(),
        )
        .toList();
  }

  void _navigateToAddSurgery() {
    Navigator.pushNamed(context, AppRoutes.addSurgeryView);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredSurgeries;

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: Column(
        children: [
          CustomGradientHeader(
            child: AppBrandHeader(subtitle: AppStrings.surgeries.tr()),
          ),
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row: Title & Subtitle + Count Badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.surgeries.tr(),
                                style: AppStyles.w700S28DarkNavy.copyWith(
                                  fontSize: 26.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                AppStrings.surgeriesTrackSubtitle.tr(),
                                style: AppStyles.w400S14Grey.copyWith(
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Count Badge (Stitch design)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
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
                                Icons.medical_services_outlined,
                                color: AppColors.white,
                                size: 13.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                AppStrings.totalCount.tr(
                                  args: ['${_surgeries.length}'],
                                ),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Main Add Surgery Button
                    CustomElevatedBtn(
                      title: AppStrings.addSurgeryRecord.tr(),
                      onPressed: _navigateToAddSurgery,
                      prefixIcon: Icon(
                        Icons.add,
                        color: AppColors.white,
                        size: 22.sp,
                      ),
                      backgroundColor: AppColors.primaryTeal,
                    ),
                    SizedBox(height: 16.h),

                    // Filter Chips
                    SpecialtyFilterChipsWidget(
                      specialties: MedicalSpecialties.specialtiesFilteration,
                      selectedSpecialty: _selectedSpecialty,
                      onSelected: (specialty) {
                        setState(() {
                          _selectedSpecialty = specialty;
                        });
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Surgeries List or Empty State
                    Expanded(
                      child: filtered.isEmpty
                          ? SurgeryEmptyStateWidget()
                          : ListView.separated(
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 12.h),
                              padding: EdgeInsets.only(bottom: 24.h),
                              itemBuilder: (context, index) {
                                final surgery = filtered[index];
                                return SurgeryCardWidget(
                                  surgery: surgery,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.surgeryDetailsView,
                                      arguments: {'surgery': surgery},
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
