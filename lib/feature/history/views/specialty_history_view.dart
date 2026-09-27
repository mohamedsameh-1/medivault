import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medivault/core/di/di.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_routes.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';
import 'package:medivault/feature/add_visit/ui/views/models/specialty_model.dart';
import 'package:medivault/feature/history/ui/viewmodel/history_cubit.dart';
import 'package:medivault/feature/history/ui/viewmodel/history_state.dart';
import 'package:medivault/feature/history/views/widgets/history_empty_state_widget.dart';
import 'package:medivault/feature/history/views/widgets/visit_timeline_card_widget.dart';

class SpecialtyHistoryView extends StatefulWidget {
  final SpecialtyModel specialty;
  final int visitCount;

  const SpecialtyHistoryView({
    super.key,
    required this.specialty,
    this.visitCount = 0,
  });

  @override
  State<SpecialtyHistoryView> createState() => _SpecialtyHistoryViewState();
}

class _SpecialtyHistoryViewState extends State<SpecialtyHistoryView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<HistoryCubit>()..loadVisitsBySpecialty(widget.specialty.id),
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
        ),
        body: SafeArea(
          child: BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              if (state is HistoryVisitsBySpecialtyLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryTeal,
                  ),
                );
              }

              List<VisitEntity> visits = [];
              if (state is HistoryVisitsBySpecialtySuccessState) {
                visits = state.visits;
              }

              final bool isEmpty = visits.isEmpty;
              final int count = visits.isEmpty
                  ? widget.visitCount
                  : visits.length;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card showing Specialty info & Visit count
                    _buildHeaderCard(isEmpty, count),
                    SizedBox(height: 20.h),

                    if (isEmpty)
                      HistoryEmptyStateWidget(specialty: widget.specialty)
                    else ...[
                      SizedBox(height: 10.h),

                      // Section Header: TIMELINE HISTORY
                      Text(
                        AppStrings.timelineHistory.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.secondaryGrey,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // List of Visit Timeline Cards
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: visits.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 14.h),
                        itemBuilder: (context, index) {
                          final visit = visits[index];
                          return VisitTimelineCardWidget(
                            visit: visit,
                            onTap: () async {
                              final cubit = context.read<HistoryCubit>();
                              final result = await Navigator.pushNamed(
                                context,
                                AppRoutes.historyVisitDetailsView,
                                arguments: {
                                  'specialty': widget.specialty,
                                  'visit': visit,
                                },
                              );
                              if (result != null) {
                                cubit.loadVisitsBySpecialty(
                                  widget.specialty.id,
                                );
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(bool isEmpty, int count) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.bannerBg,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.bannerBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                widget.specialty.iconPath,
                width: 44.r,
                height: 44.r,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.medical_services_outlined,
                  size: 24.r,
                  color: AppColors.primaryTeal,
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.specialty.title.tr(),
                  style: AppStyles.w700S24DarkNavy.copyWith(fontSize: 20.sp),
                ),
                SizedBox(height: 4.h),
                if (isEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlueButton,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '• ${AppStrings.visitsCount.tr(args: ['0'])}',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                  )
                else
                  Text(
                    AppStrings.totalRecordsVisits.tr(args: [count.toString()]),
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.secondaryGrey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
