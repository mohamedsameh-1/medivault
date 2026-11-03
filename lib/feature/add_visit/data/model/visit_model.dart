import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/visit_attachment_entity.dart';
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
    super.imagePaths,
  });

  factory VisitModel.fromFirestore(Map<String, dynamic> json, String docId) {
    final rawImagePaths = json['imagePaths'] as List<dynamic>?;
    final List<String> parsedImagePaths = rawImagePaths != null
        ? rawImagePaths.map((e) => e.toString()).toList()
        : [];

    final rawAttachments = json['attachments'] as List<dynamic>?;
    List<VisitAttachmentEntity> parsedAttachments = rawAttachments != null
        ? rawAttachments
            .map(
              (item) => VisitAttachmentModel.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList()
        : [];

    // Synthesize attachments from imagePaths if attachments list was empty
    if (parsedAttachments.isEmpty && parsedImagePaths.isNotEmpty) {
      parsedAttachments = parsedImagePaths.map((path) {
        final fileName = path.contains('/') ? path.split('/').last : path;
        return VisitAttachmentModel(
          id: path,
          fileName: fileName,
          fileUrl: path,
          fileType: 'image',
          fileSize: 0,
        );
      }).toList();
    }

    final effectiveImagePaths = parsedImagePaths.isNotEmpty
        ? parsedImagePaths
        : parsedAttachments
            .where(
              (VisitAttachmentEntity a) =>
                  a.fileType.toLowerCase() == 'image' &&
                  a.fileUrl != null &&
                  a.fileUrl!.isNotEmpty,
            )
            .map((VisitAttachmentEntity a) => a.fileUrl!)
            .toList();

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
      attachments: parsedAttachments,
      imagePaths: effectiveImagePaths,
    );
  }

  Map<String, dynamic> toFirestore() {
    final effectiveImagePaths = imagePaths.isNotEmpty
        ? imagePaths
        : attachments
            .where(
              (VisitAttachmentEntity a) =>
                  a.fileType.toLowerCase() == 'image' &&
                  a.fileUrl != null &&
                  a.fileUrl!.isNotEmpty,
            )
            .map((VisitAttachmentEntity a) => a.fileUrl!)
            .toList();

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
      'imagePaths': effectiveImagePaths,
      'attachments': attachments
          .map(
            (attachment) =>
                VisitAttachmentModel.fromEntity(attachment).toJson(),
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
      imagePaths: entity.imagePaths,
    );
  }

  static List<VisitModel> dummyVisits = [
    VisitModel(
      id: '1',
      specialtyId: 'cardiology',
      visitDate: DateTime(2026, 9, 18),
      doctorName: 'Dr. Ahmed Mansour',
      clinicHospital: 'St. Jude Heart Institute',
      symptoms: 'Routine cardiology follow-up & checkup',
      diagnosis: 'Cardiology Consultation',
    ),
    VisitModel(
      id: '2',
      specialtyId: 'orthopedics',
      visitDate: DateTime(2026, 8, 20),
      doctorName: 'Dr. Mohamed Taha',
      clinicHospital: 'Cairo Medical Center',
      symptoms: 'Knee joint pain after workout',
      diagnosis: 'Patellar tendonitis',
    ),
    VisitModel(
      id: '3',
      specialtyId: 'dermatology',
      visitDate: DateTime(2026, 7, 15),
      doctorName: 'Dr. Sara Hassan',
      clinicHospital: 'Skin Health Clinic',
      symptoms: 'Skin irritation and redness',
      diagnosis: 'Contact dermatitis',
    ),
    VisitModel(
      id: '4',
      specialtyId: 'ophthalmology',
      visitDate: DateTime(2026, 5, 10),
      doctorName: 'Dr. Tarek Radwan',
      clinicHospital: 'Eye Care International Center',
      symptoms: 'Vision check and refraction',
      diagnosis: 'Mild myopia',
    ),
  ];
}
