import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/widgets/custom_elevate_btn.dart';
import 'package:medivault/core/widgets/custom_gradient_header.dart';
import 'package:medivault/feature/profile/view/widgets/delete_account_tile.dart';
import 'package:medivault/feature/profile/view/widgets/profile_header.dart';
import 'package:medivault/feature/profile/view/widgets/profile_info_card.dart';
import 'package:medivault/feature/profile/view/widgets/profile_section.dart';
import 'package:medivault/feature/profile/view/widgets/profile_setting_type.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomGradientHeader(
            child: Column(
              children: [
                ProfileHeader(),

                // SizedBox(height: 16.h),
                const ProfileInfoCard(
                  name: 'Mohamed Sameh',
                  age: '35',
                  height: '170',
                  weight: '138',
                ),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                ProfileSection(
                  title: 'profile.account'.tr(),
                  children: [
                    ProfileSettingTile(
                      icon: Icons.badge_outlined,
                      title: 'profile.personal_information'.tr(),
                      onTap: () {},
                    ),

                    SizedBox(height: 8.h),

                    DeleteAccountTile(onTap: () {}),
                  ],
                ),

                SizedBox(height: 14.h),

                ProfileSection(
                  title: 'profile.privacy_and_sharing'.tr(),
                  children: [
                    ProfileSettingTile(
                      icon: Icons.handshake_outlined,
                      title: 'profile.sharing_permissions'.tr(),
                      subtitle: 'profile.sharing_permissions_subtitle'.tr(),
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
                      subtitle: 'English (US)',
                      trailingText: 'English',
                      onTap: () {},
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

                SizedBox(height: 24.h),
                CustomElevatedBtn(
                  backgroundColor: AppColors.red.withValues(alpha: 0.9),
                  title: 'profile.logout'.tr(),
                  onPressed: () {},
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
    );
  }
}
