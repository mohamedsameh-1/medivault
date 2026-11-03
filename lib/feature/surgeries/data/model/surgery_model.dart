import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/surgery_attachment_entity.dart';
import '../../domain/entities/surgery_entity.dart';
import 'surgery_attachment_model.dart';

class SurgeryModel extends SurgeryEntity {
  const SurgeryModel({
    super.id,
    required super.surgeryName,
    required super.specialty,
    required super.surgeryDate,
    required super.doctorName,
    required super.hospitalName,
    super.diagnosis,
    // super.anesthesiaType,
    super.notes,
    super.attachments,
    super.imagePaths,
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

    final rawImagePaths = json['imagePaths'] as List<dynamic>?;
    final List<String> parsedImagePaths = rawImagePaths != null
        ? rawImagePaths.map((e) => e.toString()).toList()
        : [];

    final rawAttachments = json['attachments'] as List<dynamic>?;
    List<SurgeryAttachmentEntity> parsedAttachments = [];

    if (rawAttachments != null) {
      for (final item in rawAttachments) {
        if (item is Map<String, dynamic>) {
          parsedAttachments.add(SurgeryAttachmentModel.fromJson(item));
        } else if (item is Map) {
          parsedAttachments.add(
            SurgeryAttachmentModel.fromJson(Map<String, dynamic>.from(item)),
          );
        } else if (item is String && item.isNotEmpty) {
          final fileName = item.contains('/') ? item.split('/').last : item;
          parsedAttachments.add(
            SurgeryAttachmentModel(
              id: item,
              fileName: fileName,
              fileUrl: item,
              fileType: 'image',
              fileSize: 0,
            ),
          );
        }
      }
    }

    // Synthesize attachments from imagePaths if attachments list was empty
    if (parsedAttachments.isEmpty && parsedImagePaths.isNotEmpty) {
      parsedAttachments = parsedImagePaths.map((path) {
        final fileName = path.contains('/') ? path.split('/').last : path;
        return SurgeryAttachmentModel(
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
              (SurgeryAttachmentEntity a) =>
                  a.fileType.toLowerCase() == 'image' &&
                  a.fileUrl != null &&
                  a.fileUrl!.isNotEmpty,
            )
            .map((SurgeryAttachmentEntity a) => a.fileUrl!)
            .toList();

    return SurgeryModel(
      id: docId,
      surgeryName: json['surgeryName'] as String? ?? '',
      specialty: normalizeSpecialtyId(rawSpecialty),
      surgeryDate: parseDate(json['surgeryDate']),
      doctorName: json['doctorName'] as String? ?? '',
      hospitalName: json['hospitalName'] as String? ?? '',
      diagnosis: json['diagnosis'] as String?,
      // anesthesiaType: json['anesthesiaType'] as String?,
      notes: json['notes'] as String?,
      attachments: parsedAttachments,
      imagePaths: effectiveImagePaths,
      createdAt: json['createdAt'] != null ? parseDate(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    final effectiveImagePaths = imagePaths.isNotEmpty
        ? imagePaths
        : attachments
            .where(
              (SurgeryAttachmentEntity a) =>
                  a.fileType.toLowerCase() == 'image' &&
                  a.fileUrl != null &&
                  a.fileUrl!.isNotEmpty,
            )
            .map((SurgeryAttachmentEntity a) => a.fileUrl!)
            .toList();

    return {
      'surgeryName': surgeryName,
      'specialty': normalizeSpecialtyId(specialty),
      'surgeryDate': Timestamp.fromDate(surgeryDate),
      'doctorName': doctorName,
      'hospitalName': hospitalName,
      'diagnosis': diagnosis ?? '',
      // 'anesthesiaType': anesthesiaType ?? '',
      'notes': notes ?? '',
      'imagePaths': effectiveImagePaths,
      'attachments': attachments
          .map(
            (attachment) =>
                SurgeryAttachmentModel.fromEntity(attachment).toJson(),
          )
          .toList(),
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
      // anesthesiaType: entity.anesthesiaType,
      notes: entity.notes,
      attachments: entity.attachments,
      imagePaths: entity.imagePaths,
      createdAt: entity.createdAt ?? DateTime.now(),
    );
  }

  static List<SurgeryModel> dummySurgeries = [
    SurgeryModel(
      id: '1',
      surgeryName: 'ACL Reconstruction',
      specialty: 'orthopedics',
      surgeryDate: DateTime(2026, 9, 12),
      doctorName: 'Dr. James Wilson',
      hospitalName: 'Mayo Clinic',
      diagnosis: 'Complete tear of anterior cruciate ligament',
      notes: 'Post-op physical therapy recommended for 6 months',
    ),
    SurgeryModel(
      id: '2',
      surgeryName: 'Cataract Surgery',
      specialty: 'ophthalmology',
      surgeryDate: DateTime(2026, 7, 24),
      doctorName: 'Dr. Emily Vance',
      hospitalName: 'Johns Hopkins Hospital',
      diagnosis: 'Senile cataract, bilateral',
      notes: 'Phacoemulsification with IOL implantation',
    ),
  ];
}
