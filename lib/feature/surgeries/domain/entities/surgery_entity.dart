class SurgeryEntity {
  final String id;
  final String surgeryName;
  final String specialty;
  final DateTime surgeryDate;
  final String doctorName;
  final String hospitalName;
  final String? diagnosis;
  final String? anesthesiaType;
  final String? notes;
  final List<String> attachments;

  const SurgeryEntity({
    required this.id,
    required this.surgeryName,
    required this.specialty,
    required this.surgeryDate,
    required this.doctorName,
    required this.hospitalName,
    this.diagnosis,
    this.anesthesiaType,
    this.notes,
    this.attachments = const [],
  });
}
