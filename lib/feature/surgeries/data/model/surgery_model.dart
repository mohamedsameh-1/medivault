import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/surgery_entity.dart';

class SurgeryModel extends SurgeryEntity {
  const SurgeryModel({
    super.id,
    required super.surgeryName,
    required super.specialty,
    required super.surgeryDate,
    required super.doctorName,
    required super.hospitalName,
    super.diagnosis,
    super.anesthesiaType,
    super.notes,
    super.attachments,
    super.createdAt,
  });

  static String normalizeSpecialtyId(String rawSpecialty) {
    final str = rawSpecialty.trim();
    if (str.isEmpty) return 'others';
    if (str.startsWith('specialties.')) {
      return str
          .replaceFirst('specialties.', '')
          .replaceFirst('.title', '')
          .toLowerCase();
    }
    return str.toLowerCase();
  }

  factory SurgeryModel.fromFirestore(Map<String, dynamic> json, String docId) {
    DateTime parseDate(dynamic field) {
      if (field is Timestamp) {
        return field.toDate();
      } else if (field is String && field.isNotEmpty) {
        return DateTime.tryParse(field) ?? DateTime.now();
      }
      return DateTime.now();
    }

    final rawSpecialty = json['specialty'] as String? ?? '';

    return SurgeryModel(
      id: docId,
      surgeryName: json['surgeryName'] as String? ?? '',
      specialty: normalizeSpecialtyId(rawSpecialty),
      surgeryDate: parseDate(json['surgeryDate']),
      doctorName: json['doctorName'] as String? ?? '',
      hospitalName: json['hospitalName'] as String? ?? '',
      diagnosis: json['diagnosis'] as String?,
      anesthesiaType: json['anesthesiaType'] as String?,
      notes: json['notes'] as String?,
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      createdAt: json['createdAt'] != null
          ? parseDate(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'surgeryName': surgeryName,
      'specialty': normalizeSpecialtyId(specialty),
      'surgeryDate': Timestamp.fromDate(surgeryDate),
      'doctorName': doctorName,
      'hospitalName': hospitalName,
      'diagnosis': diagnosis ?? '',
      'anesthesiaType': anesthesiaType ?? '',
      'notes': notes ?? '',
      'attachments': attachments,
      'createdAt': Timestamp.fromDate(createdAt ?? DateTime.now()),
    };
  }

  factory SurgeryModel.fromEntity(SurgeryEntity entity) {
    return SurgeryModel(
      id: entity.id,
      surgeryName: entity.surgeryName,
      specialty: normalizeSpecialtyId(entity.specialty),
      surgeryDate: entity.surgeryDate,
      doctorName: entity.doctorName,
      hospitalName: entity.hospitalName,
      diagnosis: entity.diagnosis,
      anesthesiaType: entity.anesthesiaType,
      notes: entity.notes,
      attachments: entity.attachments,
      createdAt: entity.createdAt ?? DateTime.now(),
    );
  }

  static List<SurgeryModel> dummySurgeries = [
    SurgeryModel(
      id: '1',
      surgeryName: 'ACL Reconstruction',
      specialty: 'orthopedics',
      surgeryDate: DateTime(2026, 9, 12),
      doctorName: 'Dr. Ahmed Mohamed',
      hospitalName: 'ABC Hospital',
    ),
    SurgeryModel(
      id: '2',
      surgeryName: 'Laparoscopic Cholecystectomy',
      specialty: 'general_surgery',
      surgeryDate: DateTime(2025, 3, 4),
      doctorName: 'Dr. Mona El-Sayed',
      hospitalName: 'Al-Noor Hospital',
    ),
    SurgeryModel(
      id: '3',
      surgeryName: 'Laser Eye Surgery (LASIK)',
      specialty: 'ophthalmology',
      surgeryDate: DateTime(2023, 11, 18),
      doctorName: 'Dr. Tarek Radwan',
      hospitalName: 'Eye Care International Center',
    ),
  ];
}
