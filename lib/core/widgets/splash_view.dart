import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_assets.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_routes.dart';
import 'package:medivault/core/utils/shared_preference.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkStartupFlow();
  }

  Future<void> _checkStartupFlow() async {
    // 1. Check Onboarding Completion
    final onboardingDone = await SharedPreference.isOnboardingCompleted();
    if (!onboardingDone) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.onboardingView);
      }
      return;
    }

    // 2. Check Firebase Authentication Session
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.loginView);
      }
      return;
    }

    // 3. Check Health Profile Setup Completion
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      final data = doc.data();
      final bool isSetupComplete = doc.exists &&
          data != null &&
          data['dateOfBirth'] != null &&
          data['gender'] != null;

      if (mounted) {
        if (isSetupComplete) {
          Navigator.pushReplacementNamed(context, AppRoutes.navigationView);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.setupView);
        }
      }
    } catch (_) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.navigationView);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.loginLogo4x,
              width: 120.w,
              height: 120.h,
            ),
            SizedBox(height: 24.h),
            const CircularProgressIndicator(
              color: AppColors.primaryTeal,
            ),
          ],
        ),
      ),
    );
  }
}
