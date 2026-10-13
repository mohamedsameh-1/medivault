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
import 'feature/profile/ui/view/edit_profile_view.dart';
import 'core/utils/bloc_observer.dart';
import 'feature/add_visit/domain/entities/visit_entity.dart';
import 'feature/history/views/edit_visit_view.dart';
import 'feature/history/views/history_view.dart';
import 'feature/history/views/history_visit_details_view.dart';
import 'feature/history/views/specialty_history_view.dart';
import 'feature/surgeries/domain/entities/surgery_entity.dart';
import 'feature/surgeries/ui/views/add_surgery_view.dart';
import 'feature/surgeries/ui/views/edit_surgery_view.dart';
import 'feature/surgeries/ui/views/surgeries_view.dart';
import 'feature/surgeries/ui/views/surgery_details_view.dart';

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
            if (settings.name == AppRoutes.specialtyHistoryView) {
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              final specialty = args['specialty'] as SpecialtyModel? ??
                  SpecialtyModel.defaultSpecialties.first;
              final visitCount = args['visitCount'] as int? ?? 0;
              return MaterialPageRoute(
                builder: (context) => SpecialtyHistoryView(
                  specialty: specialty,
                  visitCount: visitCount,
                ),
              );
            }
            if (settings.name == AppRoutes.historyVisitDetailsView) {
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              final specialty = args['specialty'] as SpecialtyModel? ??
                  SpecialtyModel.defaultSpecialties.first;
              final visit = args['visit'] ?? args['visitData'];
              Map<String, dynamic> visitDataMap = {};
              if (visit is Map<String, dynamic>) {
                visitDataMap = visit;
              } else if (visit is VisitEntity) {
                visitDataMap = {
                  'visit': visit,
                  'date': DateFormat('MMM dd, yyyy').format(visit.visitDate),
                  'doctorName': visit.doctorName,
                  'clinicName': visit.clinicHospital,
                  'reasonForVisit': visit.symptoms,
                  'diagnosis': visit.diagnosis,
                  'advisoryNotes': visit.advisoryNotes,
                  'prescriptions': visit.prescriptions,
                  'attachments': visit.attachments,
                };
              } else {
                visitDataMap = args;
              }
              return MaterialPageRoute(
                builder: (context) => HistoryVisitDetailsView(
                  specialty: specialty,
                  visitData: visitDataMap,
                ),
              );
            }
            if (settings.name == AppRoutes.visitDetailsView) {
              if (settings.arguments is Map) {
                final args = settings.arguments as Map<String, dynamic>;
                final specialty = args['specialty'] as SpecialtyModel? ??
                    SpecialtyModel.defaultSpecialties.first;
                final visit = args['visit'] ?? args['visitData'];
                Map<String, dynamic> visitDataMap = {};
                if (visit is Map<String, dynamic>) {
                  visitDataMap = visit;
                } else if (visit is VisitEntity) {
                  visitDataMap = {
                    'visit': visit,
                    'date': DateFormat('MMM dd, yyyy').format(visit.visitDate),
                    'doctorName': visit.doctorName,
                    'clinicName': visit.clinicHospital,
                    'reasonForVisit': visit.symptoms,
                    'diagnosis': visit.diagnosis,
                    'advisoryNotes': visit.advisoryNotes,
                    'prescriptions': visit.prescriptions,
                    'attachments': visit.attachments,
                  };
                } else {
                  visitDataMap = args;
                }
                return MaterialPageRoute(
                  builder: (context) => HistoryVisitDetailsView(
                    specialty: specialty,
                    visitData: visitDataMap,
                  ),
                );
              }
              final specialty = settings.arguments as SpecialtyModel?;
              return MaterialPageRoute(
                builder: (context) => VisitDetailsView(specialty: specialty),
              );
            }
            if (settings.name == AppRoutes.editVisitView) {
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              final specialty = args['specialty'] as SpecialtyModel?;
              final visitData = args['visitData'] as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder: (context) => EditVisitView(
                  specialty: specialty,
                  visitData: visitData,
                ),
              );
            }
            if (settings.name == AppRoutes.surgeryDetailsView) {
              SurgeryEntity? surgery;
              if (settings.arguments is SurgeryEntity) {
                surgery = settings.arguments as SurgeryEntity;
              } else if (settings.arguments is Map<String, dynamic>) {
                final args = settings.arguments as Map<String, dynamic>;
                surgery = args['surgery'] as SurgeryEntity?;
              }
              return MaterialPageRoute(
                builder: (context) => SurgeryDetailsView(
                  surgery: surgery,
                ),
              );
            }
            if (settings.name == AppRoutes.editSurgeryView) {
              SurgeryEntity? surgery;
              if (settings.arguments is SurgeryEntity) {
                surgery = settings.arguments as SurgeryEntity;
              } else if (settings.arguments is Map<String, dynamic>) {
                final args = settings.arguments as Map<String, dynamic>;
                surgery = args['surgery'] as SurgeryEntity?;
              }
              return MaterialPageRoute(
                builder: (context) => EditSurgeryView(
                  surgery: surgery,
                ),
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
            AppRoutes.selectSpecialtyView: (context) =>
                const SelectSpecialtyView(),
            AppRoutes.surgeriesView: (context) => const SurgeriesView(),
            AppRoutes.addSurgeryView: (context) => const AddSurgeryView(),
            AppRoutes.historyView: (context) => const HistoryView(),
          },
        );
      },
    );
  }
}
