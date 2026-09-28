import 'package:medivault/feature/surgeries/domain/entities/surgery_entity.dart';

class SurgeryModel extends SurgeryEntity {
  const SurgeryModel({
    required super.id,
    required super.surgeryName,
    required super.specialty,
    required super.surgeryDate,
    required super.doctorName,
    required super.hospitalName,
    super.diagnosis,
    super.anesthesiaType,
    super.notes,
    super.attachments,
  });

  static List<SurgeryModel> dummySurgeries = [
    SurgeryModel(
      id: '1',
      surgeryName: 'ACL Reconstruction',
      specialty: 'Orthopedics',
      surgeryDate: DateTime(2026, 9, 12),
      doctorName: 'Dr. Ahmed Mohamed',
      hospitalName: 'ABC Hospital',
    ),
    SurgeryModel(
      id: '2',
      surgeryName: 'Laparoscopic Cholecystectomy',
      specialty: 'Orthopedics',
      surgeryDate: DateTime(2025, 3, 4),
      doctorName: 'Dr. Mona El-Sayed',
      hospitalName: 'Al-Noor Specialist Hospital',
    ),
    SurgeryModel(
      id: '3',
      surgeryName: 'Laser Eye Surgery (LASIK)',
      specialty: 'Ophthalmology',
      surgeryDate: DateTime(2023, 11, 18),
      doctorName: 'Dr. Tarek Radwan',
      hospitalName: 'Eye Care International Center',
    ),
  ];
}
