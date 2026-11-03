import 'surgery_attachment_entity.dart';

class SurgeryEntity {
  final String id;
  final String surgeryName;
  final String specialty;
  final DateTime surgeryDate;
  final String doctorName;
  final String hospitalName;
  final String? diagnosis;
  // final String? anesthesiaType;
  final String? notes;
  final List<SurgeryAttachmentEntity> attachments;
  final List<String> imagePaths;
  final DateTime? createdAt;

  const SurgeryEntity({
    this.id = '',
    required this.surgeryName,
    required this.specialty,
    required this.surgeryDate,
    required this.doctorName,
    required this.hospitalName,
    this.diagnosis,
    // this.anesthesiaType,
    this.notes,
    this.attachments = const [],
    this.imagePaths = const [],
    this.createdAt,
  });

  SurgeryEntity copyWith({
    String? id,
    String? surgeryName,
    String? specialty,
    DateTime? surgeryDate,
    String? doctorName,
    String? hospitalName,
    String? diagnosis,
    String? anesthesiaType,
    String? notes,
    List<SurgeryAttachmentEntity>? attachments,
    List<String>? imagePaths,
    DateTime? createdAt,
  }) {
    return SurgeryEntity(
      id: id ?? this.id,
      surgeryName: surgeryName ?? this.surgeryName,
      specialty: specialty ?? this.specialty,
      surgeryDate: surgeryDate ?? this.surgeryDate,
      doctorName: doctorName ?? this.doctorName,
      hospitalName: hospitalName ?? this.hospitalName,
      diagnosis: diagnosis ?? this.diagnosis,
      // anesthesiaType: anesthesiaType ?? this.anesthesiaType,
      notes: notes ?? this.notes,
      attachments: attachments ?? this.attachments,
      imagePaths: imagePaths ?? this.imagePaths,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
