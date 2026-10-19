import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medivault/core/widgets/splash_view.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';
import 'package:medivault/feature/add_visit/ui/views/select_specialty_view.dart';
import 'package:medivault/feature/add_visit/ui/views/visit_details_view.dart';
import 'package:medivault/feature/history/ui/views/edit_visit_view.dart';
import 'package:medivault/feature/history/ui/views/history_visit_details_view.dart';
import 'package:medivault/feature/home/ui/views/home_view.dart';
import 'package:medivault/feature/profile/ui/view/edit_profile_view.dart';
import 'package:medivault/feature/surgeries/domain/entities/surgery_entity.dart';
import 'package:medivault/feature/surgeries/ui/views/edit_surgery_view.dart';
import 'package:medivault/feature/surgeries/ui/views/surgery_details_view.dart';
import 'app_routes.dart';
import 'package:medivault/feature/add_visit/ui/views/models/specialty_model.dart';
import 'package:medivault/feature/auth/ui/views/login_view.dart';
import 'package:medivault/feature/auth/ui/views/register_view.dart';
import 'package:medivault/feature/history/ui/views/history_view.dart';
import 'package:medivault/feature/history/ui/views/specialty_history_view.dart';
import 'package:medivault/feature/navigation/view/navigation.dart';
import 'package:medivault/feature/onboarding/ui/views/onboarding_view.dart';
import 'package:medivault/feature/setup/presentation/views/setup_view.dart';
import 'package:medivault/feature/surgeries/ui/views/add_surgery_view.dart';
import 'package:medivault/feature/surgeries/ui/views/surgeries_view.dart';

class AppRouter {
  AppRouter._();

  static Map<String, WidgetBuilder> get routes => {
    AppRoutes.splashView: (_) => const SplashView(),
    AppRoutes.onboardingView: (_) => const OnboardingView(),
    AppRoutes.loginView: (_) => const LoginView(),
    AppRoutes.registerView: (_) => const RegisterView(),
    AppRoutes.setupView: (_) => const SetupView(),
    AppRoutes.homeView: (_) => const HomeView(),
    AppRoutes.navigationView: (_) => const NavigationView(),
    AppRoutes.editProfileView: (_) => const EditProfileView(),
    AppRoutes.selectSpecialtyView: (_) => const SelectSpecialtyView(),
    AppRoutes.surgeriesView: (_) => const SurgeriesView(),
    AppRoutes.addSurgeryView: (_) => const AddSurgeryView(),
    AppRoutes.historyView: (_) => const HistoryView(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.specialtyHistoryView:
        final routeArgs = _asStringMap(args);
        final specialty =
            routeArgs['specialty'] as SpecialtyModel? ??
            SpecialtyModel.defaultSpecialties.first;
        final visitCount = routeArgs['visitCount'] as int? ?? 0;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SpecialtyHistoryView(
            specialty: specialty,
            visitCount: visitCount,
          ),
        );

      case AppRoutes.historyVisitDetailsView:
        final routeArgs = _asStringMap(args);
        final specialty =
            routeArgs['specialty'] as SpecialtyModel? ??
            SpecialtyModel.defaultSpecialties.first;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HistoryVisitDetailsView(
            specialty: specialty,
            visitData: _buildVisitData(routeArgs),
          ),
        );

      case AppRoutes.visitDetailsView:
        final specialty = args as SpecialtyModel?;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => VisitDetailsView(specialty: specialty),
        );

      case AppRoutes.editVisitView:
        final routeArgs = _asStringMap(args);

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => EditVisitView(
            specialty: routeArgs['specialty'] as SpecialtyModel?,
            visitData: routeArgs['visitData'] as Map<String, dynamic>?,
          ),
        );

      case AppRoutes.surgeryDetailsView:
        final surgery = _extractSurgery(args);

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SurgeryDetailsView(surgery: surgery),
        );

      case AppRoutes.editSurgeryView:
        final surgery = _extractSurgery(args);

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => EditSurgeryView(surgery: surgery),
        );

      default:
        return null;
    }
  }

  static Map<String, dynamic> _asStringMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    return {};
  }

  static Map<String, dynamic> _buildVisitData(Map<String, dynamic> args) {
    final visit = args['visit'] ?? args['visitData'];

    if (visit is Map<String, dynamic>) {
      return visit;
    }

    if (visit is VisitEntity) {
      return {
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
    }

    // Preserve the existing fallback behavior.
    return args;
  }

  static SurgeryEntity? _extractSurgery(Object? args) {
    if (args is SurgeryEntity) {
      return args;
    }

    if (args is Map<String, dynamic>) {
      return args['surgery'] as SurgeryEntity?;
    }

    return null;
  }
}
