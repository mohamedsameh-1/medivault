import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/custom_elevate_btn.dart';
import '../viewmodel/onboarding_cubit.dart';
import '../viewmodel/onboarding_state.dart';
import 'widgets/onboarding_page_indicator.dart';
import 'widgets/onboarding_page_item.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              final cubit = BlocProvider.of<OnboardingCubit>(context);
              final isLastPage = cubit.currentIndex == cubit.items.length - 1;
              final isFirstPage = cubit.currentIndex == 0;

              return Column(
                children: [
                  // Top Skip Bar
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 8.h,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: cubit.skip,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          backgroundColor: AppColors.lightTealBg.withOpacity(
                            0.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                        child: Text(
                          AppStrings.skip.tr(),
                          style: AppStyles.w600S14PrimaryTeal,
                        ),
                      ),
                    ),
                  ),

                  // Page View
                  Expanded(
                    child: PageView.builder(
                      controller: cubit.pageController,
                      onPageChanged: cubit.onPageChanged,
                      itemCount: cubit.items.length,
                      itemBuilder: (context, index) {
                        return OnboardingPageItem(item: cubit.items[index]);
                      },
                    ),
                  ),

                  // Page Indicator
                  OnboardingPageIndicator(
                    count: cubit.items.length,
                    currentIndex: cubit.currentIndex,
                  ),

                  SizedBox(height: 24.h),

                  // Bottom Buttons Row
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    child: isFirstPage
                        ? CustomElevatedBtn(
                            title: AppStrings.next.tr(),
                            onPressed: cubit.nextPage,
                            suffixIcon: Icon(
                              Icons.arrow_forward,
                              size: 20.sp,
                              color: AppColors.white,
                            ),
                          )
                        : Row(
                            children: [
                              // Back button
                              Expanded(
                                flex: 4,
                                child: CustomElevatedBtn(
                                  title: AppStrings.back.tr(),
                                  onPressed: cubit.previousPage,
                                  backgroundColor: AppColors.lightBlueButton,
                                  style: AppStyles.w600S16PrimaryTeal,
                                  prefixIcon: Icon(
                                    Icons.arrow_back,
                                    size: 20.sp,
                                    color: AppColors.primaryTeal,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              // Next or Get Started button
                              Expanded(
                                flex: 6,
                                child: CustomElevatedBtn(
                                  title: isLastPage
                                      ? AppStrings.getStarted.tr()
                                      : AppStrings.next.tr(),
                                  onPressed: () {
                                    if (isLastPage) {
                                      // Action on finish onboarding
                                      /// will go to login view
                                    } else {
                                      cubit.nextPage();
                                    }
                                  },
                                  suffixIcon: Icon(
                                    Icons.arrow_forward,
                                    size: 20.sp,
                                    color: AppColors.white,
                                  ),
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
      ),
    );
  }
}
