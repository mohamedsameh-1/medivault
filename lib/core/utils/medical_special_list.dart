import 'package:easy_localization/easy_localization.dart';
import 'app_strings.dart';

class MedicalSpecialties {
  MedicalSpecialties._();

  static const List<String> specialtiesFilteration = [
    'All',
    'cardiology',
    'orthopedics',
    'dermatology',
    'neurology',
    'pediatrics',
    'ophthalmology',
    'pulmonology',
    'dentistry',
    'vascular_surgery',
    'others',
  ];

  static const List<String> specialties = [
    'specialties.cardiology.title',
    'specialties.orthopedics.title',
    'specialties.dermatology.title',
    'specialties.neurology.title',
    'specialties.pediatrics.title',
    'specialties.ophthalmology.title',
    'specialties.pulmonology.title',
    'specialties.dentistry.title',
    'specialties.vascular_surgery.title',
    'specialties.gastroenterology.title',
    'specialties.urology.title',
    'specialties.gynecology_obstetrics.title',
    'specialties.ent_otolaryngology.title',
    'specialties.nephrology.title',
    'specialties.endocrinology.title',
    'specialties.oncology.title',
    'specialties.psychiatry.title',
    'specialties.rheumatology.title',
    'specialties.other_specialties.title',
  ];

  /// Returns translated UI title for a given specialty ID
  static String getSpecialtyTitle(String specialtyId) {
    if (specialtyId == 'All') return AppStrings.allSurgeries.tr();
    if (specialtyId.isEmpty) return '';

    final key = 'specialties.$specialtyId.title';
    final translated = key.tr();
    if (translated != key) return translated;

    if (specialtyId.startsWith('specialties.')) return specialtyId.tr();

    return specialtyId[0].toUpperCase() +
        specialtyId.substring(1).replaceAll('_', ' ');
  }
}
