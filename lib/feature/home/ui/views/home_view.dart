import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:medivault/core/di/di.dart';
import 'package:medivault/core/utils/app_assets.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_routes.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/core/widgets/app_brand_header.dart';
import 'package:medivault/core/widgets/custom_elevate_btn.dart';
import 'package:medivault/core/widgets/custom_gradient_header.dart';
import 'package:medivault/feature/add_visit/ui/views/models/specialty_model.dart';
import 'package:medivault/feature/home/ui/views/widgets/home_loading_widget.dart';
import '../viewmodel/home_cubit.dart';
import '../viewmodel/home_state.dart';
import 'widgets/home_doctor_visit_card_widget.dart';
import 'widgets/home_greeting_header_widget.dart';
import 'widgets/home_section_header_widget.dart';
import 'widgets/home_surgery_card_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => getIt<HomeCubit>()..loadHomeData(),
      child: Scaffold(
        backgroundColor: AppColors.screenBg,
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoadingState) {
              return const HomeLoadingWidget();
            }

            if (state is HomeFailureState) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48.sp,
                        color: AppColors.red,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        state.failure.failureMessage.tr(),
                        style: AppStyles.w400S14Grey,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      CustomElevatedBtn(
                        title: 'common.confirm'.tr(),
                        onPressed: () =>
                            context.read<HomeCubit>().loadHomeData(),
                      ),
                    ],
                  ),
                ),
              );
            }

            final homeData = state is HomeSuccessState ? state.homeData : null;

            if (homeData == null) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                //Top app bar
                CustomGradientHeader(
                  child: AppBrandHeader(subtitle: AppStrings.home.tr()),
                ),
                // Top Greeting & Vault Status Header
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.primaryTeal,
                    onRefresh: () => context.read<HomeCubit>().loadHomeData(),
                    child: SafeArea(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          // vertical: 16.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HomeGreetingHeaderWidget(
                              userName: homeData.userName,
                            ),

                            SizedBox(height: 24.h),

                            // Recent Surgeries Section Header
                            HomeSectionHeaderWidget(
                              title: AppStrings.recentSurgeries.tr(),
                              count: homeData.totalSurgeriesCount,
                              onSeeAllTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.surgeriesView,
                                );
                              },
                            ),

                            SizedBox(height: 12.h),

                            // Surgeries List or Empty Placeholder
                            if (homeData.recentSurgeries.isEmpty)
                              const EmptySurgery()
                            else
                              ...homeData.recentSurgeries.map(
                                (surgery) => Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: HomeSurgeryCardWidget(
                                    surgery: surgery,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.surgeryDetailsView,
                                        arguments: surgery,
                                      );
                                    },
                                  ),
                                ),
                              ),

                            SizedBox(height: 12.h),

                            // Recent Doctor Visits Section Header
                            HomeSectionHeaderWidget(
                              title: AppStrings.recentDoctorVisits.tr(),
                              count: homeData.totalVisitsCount,
                              onSeeAllTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.historyView,
                                );
                              },
                            ),

                            SizedBox(height: 12.h),

                            // Doctor Visits List or Empty Placeholder
                            if (homeData.recentVisits.isEmpty)
                              const EmptyDoctorVisit()
                            else
                              ...homeData.recentVisits.map(
                                (visit) => Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: HomeDoctorVisitCardWidget(
                                    visit: visit,
                                    onTap: () {
                                      final specialty = SpecialtyModel
                                          .defaultSpecialties
                                          .firstWhere(
                                            (s) => s.id == visit.specialtyId,
                                            orElse: () => SpecialtyModel
                                                .defaultSpecialties
                                                .first,
                                          );
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.historyVisitDetailsView,
                                        // arguments: visit,
                                        arguments: {
                                          'visit': visit,
                                          'specialty': specialty,
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),

                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
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

class EmptyDoctorVisit extends StatelessWidget {
  const EmptyDoctorVisit({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          LottieBuilder.asset(
            AppAssets.emptyBoxLottie,
            height: 128.h,
            width: 128.w,
          ),
          Text(
            AppStrings.noRecentVisitsHome.tr(),
            style: AppStyles.w400S14Grey,
          ),

          SizedBox(height: 16.h),

          CustomElevatedBtn(
            title: 'add_visit'.tr(),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.selectSpecialtyView);
            },
          ),
        ],
      ),
    );
  }
}

class EmptySurgery extends StatelessWidget {
  const EmptySurgery({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          LottieBuilder.asset(
            AppAssets.emptyBoxLottie,
            height: 128.h,
            width: 128.w,
          ),
          Text(
            AppStrings.noRecentSurgeriesHome.tr(),
            style: AppStyles.w400S14Grey,
          ),

          SizedBox(height: 16.h),
          CustomElevatedBtn(
            title: AppStrings.addSurgery.tr(),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addSurgeryView);
            },
          ),
        ],
      ),
    );
  }
}
