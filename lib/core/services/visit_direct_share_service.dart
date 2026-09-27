import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';

import '../../feature/add_visit/domain/entities/visit_entity.dart';
import '../utils/app_strings.dart';

@injectable
class VisitDirectShareService {
  /// Builds a clean, formatted text representation of [visit].
  /// Only includes optional sections if they contain actual data.
  String buildShareText({
    required VisitEntity visit,
    required String specialtyTitle,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('🏥 MediVault - $specialtyTitle');
    buffer.writeln();

    final formattedDate = DateFormat('MMM dd, yyyy').format(visit.visitDate);
    buffer.writeln('${AppStrings.visitDate.tr()}: $formattedDate');

    if (visit.doctorName.trim().isNotEmpty) {
      buffer.writeln(
        '${AppStrings.doctorName.tr()}: ${visit.doctorName.trim()}',
      );
    }

    if (visit.clinicHospital.trim().isNotEmpty) {
      buffer.writeln(
        '${AppStrings.clinicHospital.tr()}: ${visit.clinicHospital.trim()}',
      );
    }

    if (visit.symptoms.trim().isNotEmpty) {
      buffer.writeln();
      buffer.writeln('📋 ${AppStrings.symptoms.tr()}:');
      buffer.writeln(visit.symptoms.trim());
    }

    if (visit.diagnosis.trim().isNotEmpty) {
      buffer.writeln();
      buffer.writeln('🔬 ${AppStrings.doctorDiagnosis.tr()}:');
      buffer.writeln(visit.diagnosis.trim());
    }

    if (visit.advisoryNotes != null && visit.advisoryNotes!.trim().isNotEmpty) {
      buffer.writeln();
      buffer.writeln('💡 ${AppStrings.advisoryNotes.tr()}:');
      buffer.writeln(visit.advisoryNotes!.trim());
    }

    if (visit.prescriptions != null && visit.prescriptions!.trim().isNotEmpty) {
      buffer.writeln();
      buffer.writeln('💊 ${AppStrings.prescriptions.tr()}:');
      buffer.writeln(visit.prescriptions!.trim());
    }

    return buffer.toString().trim();
  }

  /// Shares the [visit] details directly as text using [share_plus].
  Future<void> shareVisitAsText({
    required VisitEntity visit,
    required String specialtyTitle,
  }) async {
    final text = buildShareText(visit: visit, specialtyTitle: specialtyTitle);

    await Share.share(text, subject: '$specialtyTitle - ${visit.doctorName}');
  }
}
