import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/di/di.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_routes.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/core/widgets/app_brand_header.dart';
import 'package:medivault/core/widgets/custom_gradient_header.dart';
import 'package:medivault/feature/add_visit/ui/views/models/specialty_model.dart';
import 'package:medivault/feature/history/ui/viewmodel/history_cubit.dart';
import 'package:medivault/feature/history/ui/viewmodel/history_state.dart';
import 'package:medivault/feature/history/ui/views/widgets/history_specialty_card_widget.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final specialties = SpecialtyModel.defaultSpecialties;

    return BlocProvider(
      create: (context) => getIt<HistoryCubit>()..loadVisitCounts(),
      child: Scaffold(
        backgroundColor: AppColors.screenBg,
        body: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            Map<String, int> countsMap = {};
            if (state is HistoryVisitCountsSuccessState) {
              countsMap = state.visitCounts;
            }

            return Column(
              children: [
                CustomGradientHeader(
                  child: AppBrandHeader(subtitle: 'history'.tr()),
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      /// History sub title
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 14.h,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            AppStrings.historySubtitle.tr(),
                            style: AppStyles.w400S14Grey.copyWith(
                              color: AppColors.darkNavyText,
                            ),
                          ),
                        ),
                      ),

                      // Specialties 2-Column Grid
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                        ).copyWith(bottom: 24.h),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 14.h,
                                crossAxisSpacing: 14.w,
                                childAspectRatio: 0.9,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final specialty = specialties[index];
                            final visitCount = countsMap[specialty.id] ?? 0;

                            return HistorySpecialtyCardWidget(
                              specialty: specialty,
                              visitCount: visitCount,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.specialtyHistoryView,
                                  arguments: {
                                    'specialty': specialty,
                                    'visitCount': visitCount,
                                  },
                                );
                              },
                            );
                          }, childCount: specialties.length),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
