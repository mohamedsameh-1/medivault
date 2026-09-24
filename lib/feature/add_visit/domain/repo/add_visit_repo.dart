import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../entities/visit_entity.dart';

abstract class AddVisitRepo {
  Future<Either<Failure, Unit>> saveVisit(VisitEntity visit);
}
