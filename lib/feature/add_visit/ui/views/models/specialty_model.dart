import 'package:medivault/core/utils/app_assets.dart';
import 'package:medivault/core/utils/medical_special_list.dart';

class SpecialtyModel {
  final String id;
  final String title;
  final String description;
  final String iconPath;

  const SpecialtyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
  });

  // static const List<SpecialtyModel> defaultSpecialties = [
  //   SpecialtyModel(
  //     id: 'cardiology',
  //     title: 'specialties.cardiology.title',
  //     description: 'specialties.cardiology.description',
  //     iconPath: AppAssets.cardiology,
  //   ),
  //   SpecialtyModel(
  //     id: 'orthopedics',
  //     title: 'specialties.orthopedics.title',
  //     description: 'specialties.orthopedics.description',
  //     iconPath: AppAssets.orthopedics,
  //   ),
  //   SpecialtyModel(
  //     id: 'dermatology',
  //     title: 'specialties.dermatology.title',
  //     description: 'specialties.dermatology.description',
  //     iconPath: AppAssets.dermatology,
  //   ),
  //   SpecialtyModel(
  //     id: 'neurology',
  //     title: 'specialties.neurology.title',
  //     description: 'specialties.neurology.description',
  //     iconPath: AppAssets.neurology,
  //   ),
  //   SpecialtyModel(
  //     id: 'pediatrics',
  //     title: 'specialties.pediatrics.title',
  //     description: 'specialties.pediatrics.description',
  //     iconPath: AppAssets.pediatrics,
  //   ),
  //   SpecialtyModel(
  //     id: 'ophthalmology',
  //     title: 'specialties.ophthalmology.title',
  //     description: 'specialties.ophthalmology.description',
  //     iconPath: AppAssets.ophthalmology,
  //   ),
  //   SpecialtyModel(
  //     id: 'pulmonology',
  //     title: 'specialties.pulmonology.title',
  //     description: 'specialties.pulmonology.description',
  //     iconPath: AppAssets.pulmonology,
  //   ),
  //   SpecialtyModel(
  //     id: 'dentistry',
  //     title: 'specialties.dentistry.title',
  //     description: 'specialties.dentistry.description',
  //     iconPath: AppAssets.dentistry,
  //   ),
  //   SpecialtyModel(
  //     id: 'vascular_surgery',
  //     title: 'specialties.vascular_surgery.title',
  //     description: 'specialties.vascular_surgery.description',
  //     iconPath: AppAssets.vascularSurgery,
  //   ),
  //   SpecialtyModel(
  //     id: 'gastroenterology',
  //     title: 'specialties.gastroenterology.title',
  //     description: 'specialties.gastroenterology.description',
  //     iconPath: AppAssets.gastroenterology,
  //   ),
  //   SpecialtyModel(
  //     id: 'urology',
  //     title: 'specialties.urology.title',
  //     description: 'specialties.urology.description',
  //     iconPath: AppAssets.urology,
  //   ),
  //   SpecialtyModel(
  //     id: 'gynecology_obstetrics',
  //     title: 'specialties.gynecology_obstetrics.title',
  //     description: 'specialties.gynecology_obstetrics.description',
  //     iconPath: AppAssets.gynecologyObstetrics,
  //   ),
  //   SpecialtyModel(
  //     id: 'ent_otolaryngology',
  //     title: 'specialties.ent_otolaryngology.title',
  //     description: 'specialties.ent_otolaryngology.description',
  //     iconPath: AppAssets.entOtolaryngology,
  //   ),
  //   SpecialtyModel(
  //     id: 'nephrology',
  //     title: 'specialties.nephrology.title',
  //     description: 'specialties.nephrology.description',
  //     iconPath: AppAssets.nephrology,
  //   ),
  //   SpecialtyModel(
  //     id: 'endocrinology',
  //     title: 'specialties.endocrinology.title',
  //     description: 'specialties.endocrinology.description',
  //     iconPath: AppAssets.endocrinology,
  //   ),
  //   SpecialtyModel(
  //     id: 'oncology',
  //     title: 'specialties.oncology.title',
  //     description: 'specialties.oncology.description',
  //     iconPath: AppAssets.oncology,
  //   ),
  //   SpecialtyModel(
  //     id: 'psychiatry',
  //     title: 'specialties.psychiatry.title',
  //     description: 'specialties.psychiatry.description',
  //     iconPath: AppAssets.psychiatry,
  //   ),
  //   SpecialtyModel(
  //     id: 'rheumatology',
  //     title: 'specialties.rheumatology.title',
  //     description: 'specialties.rheumatology.description',
  //     iconPath: AppAssets.rheumatology,
  //   ),
  //   SpecialtyModel(
  //     id: 'other_specialties',
  //     title: 'specialties.other_specialties.title',
  //     description: 'specialties.other_specialties.description',
  //     iconPath: AppAssets.otherSpecialties,
  //   ),
  // ];
  static List<SpecialtyModel> defaultSpecialties = [
    SpecialtyModel(
      id: 'cardiology',
      title: MedicalSpecialties.specialties[0],
      description: 'specialties.cardiology.description',
      iconPath: AppAssets.cardiology,
    ),
    SpecialtyModel(
      id: 'orthopedics',
      title: MedicalSpecialties.specialties[1],
      description: 'specialties.orthopedics.description',
      iconPath: AppAssets.orthopedics,
    ),
    SpecialtyModel(
      id: 'dermatology',
      title: MedicalSpecialties.specialties[2],
      description: 'specialties.dermatology.description',
      iconPath: AppAssets.dermatology,
    ),
    SpecialtyModel(
      id: 'neurology',
      title: MedicalSpecialties.specialties[3],
      description: 'specialties.neurology.description',
      iconPath: AppAssets.neurology,
    ),
    SpecialtyModel(
      id: 'pediatrics',
      title: MedicalSpecialties.specialties[4],
      description: 'specialties.pediatrics.description',
      iconPath: AppAssets.pediatrics,
    ),
    SpecialtyModel(
      id: 'ophthalmology',
      title: MedicalSpecialties.specialties[5],
      description: 'specialties.ophthalmology.description',
      iconPath: AppAssets.ophthalmology,
    ),
    SpecialtyModel(
      id: 'pulmonology',
      title: MedicalSpecialties.specialties[6],
      description: 'specialties.pulmonology.description',
      iconPath: AppAssets.pulmonology,
    ),
    SpecialtyModel(
      id: 'dentistry',
      title: MedicalSpecialties.specialties[7],
      description: 'specialties.dentistry.description',
      iconPath: AppAssets.dentistry,
    ),
    SpecialtyModel(
      id: 'vascular_surgery',
      title: MedicalSpecialties.specialties[8],
      description: 'specialties.vascular_surgery.description',
      iconPath: AppAssets.vascularSurgery,
    ),
    SpecialtyModel(
      id: 'gastroenterology',
      title: MedicalSpecialties.specialties[9],
      description: 'specialties.gastroenterology.description',
      iconPath: AppAssets.gastroenterology,
    ),
    SpecialtyModel(
      id: 'urology',
      title: MedicalSpecialties.specialties[10],
      description: 'specialties.urology.description',
      iconPath: AppAssets.urology,
    ),
    SpecialtyModel(
      id: 'gynecology_obstetrics',
      title: MedicalSpecialties.specialties[11],
      description: 'specialties.gynecology_obstetrics.description',
      iconPath: AppAssets.gynecologyObstetrics,
    ),
    SpecialtyModel(
      id: 'ent_otolaryngology',
      title: MedicalSpecialties.specialties[12],
      description: 'specialties.ent_otolaryngology.description',
      iconPath: AppAssets.entOtolaryngology,
    ),
    SpecialtyModel(
      id: 'nephrology',
      title: MedicalSpecialties.specialties[13],
      description: 'specialties.nephrology.description',
      iconPath: AppAssets.nephrology,
    ),
    SpecialtyModel(
      id: 'endocrinology',
      title: MedicalSpecialties.specialties[14],
      description: 'specialties.endocrinology.description',
      iconPath: AppAssets.endocrinology,
    ),
    SpecialtyModel(
      id: 'oncology',
      title: MedicalSpecialties.specialties[15],
      description: 'specialties.oncology.description',
      iconPath: AppAssets.oncology,
    ),
    SpecialtyModel(
      id: 'psychiatry',
      title: MedicalSpecialties.specialties[16],
      description: 'specialties.psychiatry.description',
      iconPath: AppAssets.psychiatry,
    ),
    SpecialtyModel(
      id: 'rheumatology',
      title: MedicalSpecialties.specialties[17],
      description: 'specialties.rheumatology.description',
      iconPath: AppAssets.rheumatology,
    ),
    SpecialtyModel(
      id: 'other_specialties',
      title: MedicalSpecialties.specialties[18],
      description: 'specialties.other_specialties.description',
      iconPath: AppAssets.otherSpecialties,
    ),
  ];
}
