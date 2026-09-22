import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_routes.dart';
import 'package:medivault/core/widgets/confirmation_dialog.dart';
import 'package:medivault/core/widgets/custom_elevate_btn.dart';
import 'package:medivault/core/widgets/custom_gradient_header.dart';
import 'package:medivault/core/widgets/custom_message_dialog.dart';
import 'package:medivault/feature/profile/domain/entities/profile_entity.dart';
import 'package:medivault/feature/profile/ui/viewmodel/profile_cubit.dart';
import 'package:medivault/feature/profile/ui/viewmodel/profile_state.dart';
import 'package:medivault/feature/profile/view/widgets/delete_account_tile.dart';
import 'package:medivault/core/widgets/app_brand_header.dart';
import 'package:medivault/feature/profile/view/widgets/profile_info_card.dart';
import 'package:medivault/feature/profile/view/widgets/profile_section.dart';
import 'package:medivault/feature/profile/view/widgets/profile_setting_type.dart';
import 'package:medivault/feature/profile/view/widgets/language_selection_bottom_sheet.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLogoutSuccessState ||
            state is ProfileDeleteAccountSuccessState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.loginView,
            (route) => false,
          );
        } else if (state is ProfileFailureState) {
          showDialog(
            context: context,
            builder: (context) => CustomMessageDialog(
              message: state.failure.failureMessage.tr(),
              type: MessageType.error,
            ),
          );
        } else if (state is ProfileLogoutFailureState) {
          showDialog(
            context: context,
            builder: (context) => CustomMessageDialog(
              message: state.failure.failureMessage.tr(),
              type: MessageType.error,
            ),
          );
        } else if (state is ProfileDeleteAccountFailureState) {
          showDialog(
            context: context,
            builder: (context) => CustomMessageDialog(
              message: state.failure.failureMessage.tr(),
              type: MessageType.error,
            ),
          );
        } else if (state is ProfileUpdateFailureState) {
          showDialog(
            context: context,
            builder: (context) => CustomMessageDialog(
              message: state.failure.failureMessage.tr(),
              type: MessageType.error,
            ),
          );
        }
      },
      builder: (context, state) {
        ProfileEntity? profile;
        if (state is ProfileSuccessState) {
          profile = state.profileEntity;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomGradientHeader(
              child: AppBrandHeader(subtitle: 'profile.title'.tr()),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // SizedBox(height: 6.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          Skeletonizer(
                            enabled: state is ProfileLoadingState,
                            effect: ShimmerEffect(
                              baseColor: AppColors.primaryTealLight,
                              highlightColor: AppColors.bannerBg,
                              duration: const Duration(milliseconds: 1200),
                            ),
                            child: ProfileInfoCard(
                              name: profile?.fullName ?? 'User',
                              age: _calculateAge(profile?.dateOfBirth),
                              height: profile?.height != null
                                  ? '${profile!.height!.toStringAsFixed(0)} cm'
                                  : '--',
                              weight: profile?.weight != null
                                  ? '${profile!.weight!.toStringAsFixed(0)} kg'
                                  : '--',
                            ),
                          ),

                          // if (state is ProfileLoadingState)
                          //   Skeletonizer(
                          //     enabled: true,
                          //     child: ProfileInfoCard(
                          //       name: '',
                          //       age: _calculateAge(profile?.dateOfBirth),
                          //       height: profile?.height != null
                          //           ? '${profile!.height!.toStringAsFixed(0)} cm'
                          //           : '170 cm',
                          //       weight: profile?.weight != null
                          //           ? '${profile!.weight!.toStringAsFixed(0)} kg'
                          //           : '62 kg',
                          //     ),
                          //   )
                          // // const Center(
                          // //   child: Padding(
                          // //     padding: EdgeInsets.symmetric(vertical: 20),
                          // //     child: CircularProgressIndicator(
                          // //       color: AppColors.primaryTeal,
                          // //     ),
                          // //   ),
                          // // )
                          // else
                          //   ProfileInfoCard(
                          //     name: profile?.fullName ?? 'User',
                          //     age: _calculateAge(profile?.dateOfBirth),
                          //     height: profile?.height != null
                          //         ? '${profile!.height!.toStringAsFixed(0)} cm'
                          //         : '--',
                          //     weight: profile?.weight != null
                          //         ? '${profile!.weight!.toStringAsFixed(0)} kg'
                          //         : '--',
                          //   ),
                          SizedBox(height: 16.h),

                          ProfileSection(
                            title: 'profile.account'.tr(),
                            children: [
                              ProfileSettingTile(
                                icon: Icons.badge_outlined,
                                title: 'profile.personal_information'.tr(),
                                onTap: () async {
                                  final updatedProfile =
                                      await Navigator.pushNamed(
                                        context,
                                        AppRoutes.editProfileView,
                                        arguments: profile,
                                      );
                                  if (updatedProfile is ProfileEntity &&
                                      context.mounted) {
                                    context
                                        .read<ProfileCubit>()
                                        .updateProfileData(updatedProfile);
                                  }
                                },
                              ),

                              SizedBox(height: 8.h),

                              DeleteAccountTile(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ConfirmationDialog(
                                        title: 'profile.delete_account'.tr(),
                                        content:
                                            'profile.delete_account_confirmation'
                                                .tr(),
                                        cancelText: 'common.cancel'.tr(),
                                        confirmText: 'common.confirm'.tr(),
                                        onConfirm: () {
                                          context
                                              .read<ProfileCubit>()
                                              .deleteAccount();
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 14.h),

                          ProfileSection(
                            title: 'profile.privacy_and_sharing'.tr(),
                            children: [
                              ProfileSettingTile(
                                icon: Icons.handshake_outlined,
                                title: 'profile.sharing_permissions'.tr(),
                                subtitle: 'profile.sharing_permissions_subtitle'
                                    .tr(),
                                onTap: () {},
                              ),
                            ],
                          ),

                          SizedBox(height: 14.h),

                          ProfileSection(
                            title: 'profile.app_settings'.tr(),
                            children: [
                              ProfileSettingTile(
                                icon: Icons.translate,
                                title: 'profile.language'.tr(),
                                subtitle: context.locale.languageCode == 'ar'
                                    ? 'العربية'
                                    : 'English (US)',
                                trailingText: context.locale.languageCode == 'ar'
                                    ? 'العربية'
                                    : 'English',
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) =>
                                        const LanguageSelectionBottomSheet(),
                                  );
                                },
                              ),

                              SizedBox(height: 8.h),

                              ProfileSettingTile(
                                icon: Icons.light_mode_outlined,
                                title: 'profile.theme'.tr(),
                                subtitle: 'profile.theme_subtitle'.tr(),
                                trailingText: 'profile.light'.tr(),
                                onTap: () {},
                              ),
                            ],
                          ),

                          SizedBox(height: 32.h),
                          CustomElevatedBtn(
                            backgroundColor: AppColors.red.withValues(
                              alpha: 0.9,
                            ),
                            title: 'profile.logout'.tr(),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return ConfirmationDialog(
                                    title: 'profile.logout'.tr(),
                                    content: 'profile.logout_confirmation'.tr(),
                                    cancelText: 'common.cancel'.tr(),
                                    confirmText: 'common.confirm'.tr(),
                                    onConfirm: () {
                                      context.read<ProfileCubit>().logout();
                                    },
                                  );
                                },
                              );
                            },
                            prefixIcon: Icon(
                              Icons.logout,
                              size: 17.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _calculateAge(DateTime? dob) {
    if (dob == null) return '--';
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return '$age yrs';
  }
}
