import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/feature/surgeries/domain/entities/surgery_entity.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/app_strings.dart';

@injectable
class SurgeryDirectShareService {
  /// Builds a clean, formatted text representation of [surgery].
  /// Only includes optional sections if they contain actual data.
  String buildShareText({required SurgeryEntity surgery}) {
    final buffer = StringBuffer();

    buffer.writeln('🏥 MediVault - ${surgery.surgeryName}');
    buffer.writeln();

    final formattedDate = DateFormat(
      'MMM dd, yyyy',
    ).format(surgery.surgeryDate);

    buffer.writeln('${AppStrings.surgeryDate.tr()}: $formattedDate');

    if (surgery.specialty.trim().isNotEmpty) {
      buffer.writeln(
        '${AppStrings.medicalSpecialty.tr()}: ${surgery.specialty.trim()}',
      );
    }

    if (surgery.doctorName.trim().isNotEmpty) {
      buffer.writeln(
        '${AppStrings.doctorName.tr()}: ${surgery.doctorName.trim()}',
      );
    }

    if (surgery.hospitalName.trim().isNotEmpty) {
      buffer.writeln(
        '${AppStrings.hospitalSurgicalCenter.tr()}: ${surgery.hospitalName.trim()}',
      );
    }

    if (surgery.diagnosis != null && surgery.diagnosis!.trim().isNotEmpty) {
      buffer.writeln();
      buffer.writeln('🔬 ${AppStrings.doctorDiagnosis.tr()}:');
      buffer.writeln(surgery.diagnosis!.trim());
    }

    if (surgery.notes != null && surgery.notes!.trim().isNotEmpty) {
      buffer.writeln();
      buffer.writeln('📝 ${AppStrings.notes.tr()}:');
      buffer.writeln(surgery.notes!.trim());
    }

    return buffer.toString().trim();
  }

  /// Shares the [surgery] details directly as text using [share_plus].
  Future<void> shareSurgeryAsText({required SurgeryEntity surgery}) async {
    final text = buildShareText(surgery: surgery);

    await Share.share(
      text,
      subject: '${surgery.surgeryName} - ${surgery.doctorName}',
    );
  }
}
