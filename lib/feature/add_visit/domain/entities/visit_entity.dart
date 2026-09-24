import 'visit_attachment_entity.dart';

class VisitEntity {
  final String? id;
  final String specialtyId;
  final DateTime visitDate;
  final String doctorName;
  final String clinicHospital;
  final String symptoms;
  final String diagnosis;
  final String? advisoryNotes;
  final String? prescriptions;
  final DateTime? createdAt;
  final List<VisitAttachmentEntity> attachments;

  const VisitEntity({
    this.id,
    required this.specialtyId,
    required this.visitDate,
    required this.doctorName,
    required this.clinicHospital,
    required this.symptoms,
    required this.diagnosis,
    this.advisoryNotes,
    this.prescriptions,
    this.createdAt,
    this.attachments = const [],
  });
}
