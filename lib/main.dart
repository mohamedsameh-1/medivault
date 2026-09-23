import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/feature/home/ui/views/home_view.dart';
import 'package:medivault/feature/navigation/view/navigation.dart';
import 'package:medivault/feature/setup/presentation/views/setup_view.dart';
import 'package:medivault/firebase_options.dart';
import 'core/di/di.dart';
import 'core/utils/app_routes.dart';
import 'core/utils/app_theme.dart';
import 'core/widgets/splash_view.dart';
import 'feature/add_visit/ui/views/models/specialty_model.dart';
import 'feature/add_visit/ui/views/select_specialty_view.dart';
import 'feature/add_visit/ui/views/visit_details_view.dart';
import 'feature/auth/ui/views/login_view.dart';
import 'feature/auth/ui/views/register_view.dart';
import 'feature/onboarding/ui/views/onboarding_view.dart';
import 'feature/profile/view/edit_profile_view.dart';
import 'core/utils/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = MyBlocObserver();
  configureDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'MediVault',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          initialRoute: AppRoutes.splashView,
          onGenerateRoute: (settings) {
            if (settings.name == AppRoutes.visitDetailsView) {
              final specialty = settings.arguments as SpecialtyModel?;
              return MaterialPageRoute(
                builder: (context) => VisitDetailsView(specialty: specialty),
              );
            }
            return null;
          },
          routes: {
            AppRoutes.splashView: (context) => const SplashView(),
            AppRoutes.onboardingView: (context) => const OnboardingView(),
            AppRoutes.loginView: (context) => const LoginView(),
            AppRoutes.registerView: (context) => const RegisterView(),
            AppRoutes.setupView: (context) => const SetupView(),
            AppRoutes.homeView: (context) => const HomeView(),
            AppRoutes.navigationView: (context) => const NavigationView(),
            AppRoutes.editProfileView: (context) => const EditProfileView(),
            AppRoutes.selectSpecialtyView: (context) => const SelectSpecialtyView(),
          },
        );
      },
    );
  }
}
