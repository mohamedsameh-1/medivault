import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../entities/surgery_entity.dart';

abstract class SurgeriesRepo {
  Future<Either<Failure, List<SurgeryEntity>>> getSurgeries();
  Future<Either<Failure, SurgeryEntity>> getSurgeryDetails(String surgeryId);
  Future<Either<Failure, Unit>> addSurgery(SurgeryEntity surgery);
  Future<Either<Failure, Unit>> updateSurgery(SurgeryEntity surgery);
  Future<Either<Failure, Unit>> deleteSurgery(String surgeryId);
}
