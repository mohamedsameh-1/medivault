import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/visit_entity.dart';
import 'visit_attachment_model.dart';

class VisitModel extends VisitEntity {
  const VisitModel({
    super.id,
    required super.specialtyId,
    required super.visitDate,
    required super.doctorName,
    required super.clinicHospital,
    required super.symptoms,
    required super.diagnosis,
    super.advisoryNotes,
    super.prescriptions,
    super.createdAt,
    super.attachments,
  });

  factory VisitModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return VisitModel(
      id: docId,
      specialtyId: json['specialtyId'] ?? '',
      visitDate: (json['visitDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      doctorName: json['doctorName'] ?? '',
      clinicHospital: json['clinicHospital'] ?? '',
      symptoms: json['symptoms'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      advisoryNotes: json['advisoryNotes'],
      prescriptions: json['prescriptions'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map(
                (item) => VisitAttachmentModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'specialtyId': specialtyId,
      'visitDate': Timestamp.fromDate(visitDate),
      'doctorName': doctorName,
      'clinicHospital': clinicHospital,
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'advisoryNotes': advisoryNotes ?? '',
      'prescriptions': prescriptions ?? '',
      'createdAt': Timestamp.fromDate(createdAt ?? DateTime.now()),
      'attachments': attachments
          .map(
            (attachment) => VisitAttachmentModel.fromEntity(attachment).toJson(),
          )
          .toList(),
    };
  }

  factory VisitModel.fromEntity(VisitEntity entity) {
    return VisitModel(
      id: entity.id,
      specialtyId: entity.specialtyId,
      visitDate: entity.visitDate,
      doctorName: entity.doctorName,
      clinicHospital: entity.clinicHospital,
      symptoms: entity.symptoms,
      diagnosis: entity.diagnosis,
      advisoryNotes: entity.advisoryNotes,
      prescriptions: entity.prescriptions,
      createdAt: entity.createdAt ?? DateTime.now(),
      attachments: entity.attachments,
    );
  }
}
