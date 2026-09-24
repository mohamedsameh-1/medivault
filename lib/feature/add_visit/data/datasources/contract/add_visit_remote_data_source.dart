import 'package:dartz/dartz.dart';
import 'package:medivault/core/utils/failure.dart';
import '../../../domain/entities/visit_entity.dart';

abstract class AddVisitRemoteDataSource {
  Future<Either<Failure, Unit>> saveVisit(VisitEntity visit);
}
