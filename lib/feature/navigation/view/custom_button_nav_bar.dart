import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
    required this.onAddVisitPressed,
  });

  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onAddVisitPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _NavItem(
                      icon: Icons.home_outlined,
                      label: 'home'.tr(),
                      isSelected: currentIndex == 0,
                      onTap: () => onItemSelected(0),
                    ),
                  ),

                  Expanded(
                    child: _NavItem(
                      icon: Icons.history,
                      label: 'history'.tr(),
                      isSelected: currentIndex == 1,
                      onTap: () => onItemSelected(1),
                    ),
                  ),

                  SizedBox(width: 80.w),

                  Expanded(
                    child: _NavItem(
                      icon: Icons.description_outlined,
                      label: 'reports'.tr(),
                      isSelected: currentIndex == 2,
                      onTap: () => onItemSelected(2),
                    ),
                  ),

                  Expanded(
                    child: _NavItem(
                      icon: Icons.person_outline,
                      label: 'profile_nav'.tr(),
                      isSelected: currentIndex == 3,
                      onTap: () => onItemSelected(3),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: -28.h,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: onAddVisitPressed,
                    child: Container(
                      width: 68.w,
                      height: 68.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryTeal,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryTeal.withValues(
                              alpha: 0.25,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(Icons.add, size: 36.sp, color: Colors.white),
                    ),
                  ),

                  SizedBox(height: 7.h),

                  Text(
                    'add_visit'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkNavyText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primaryTeal : AppColors.darkNavyText;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 27.sp, color: color),

          SizedBox(height: 3.h),

          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
