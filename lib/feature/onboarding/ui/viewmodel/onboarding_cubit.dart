import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_strings.dart';
import '../model/onboarding_item.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final PageController pageController = PageController();
  int currentIndex = 0;

  final List<OnboardingItem> items = const [
    OnboardingItem(
      titleKey: AppStrings.onboarding1Title,
      descKey: AppStrings.onboarding1Desc,
      svgAsset: AppAssets.onboarding1Svg,
    ),
    OnboardingItem(
      titleKey: AppStrings.onboarding2Title,
      descKey: AppStrings.onboarding2Desc,
      svgAsset: AppAssets.onboarding2Svg,
    ),
    OnboardingItem(
      titleKey: AppStrings.onboarding3Title,
      descKey: AppStrings.onboarding3Desc,
      svgAsset: AppAssets.onboarding3Svg,
    ),
  ];

  OnboardingCubit() : super(OnboardingInitialState());

  void onPageChanged(int index) {
    currentIndex = index;
    emit(OnboardingPageChangedState(pageIndex: currentIndex));
  }

  void nextPage() {
    if (currentIndex < items.length - 1) {
      pageController.animateToPage(
        currentIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentIndex > 0) {
      pageController.animateToPage(
        currentIndex - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// will changed
  /// when user click on skip button should move to login view
  void skip() {
    pageController.animateToPage(
      items.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
