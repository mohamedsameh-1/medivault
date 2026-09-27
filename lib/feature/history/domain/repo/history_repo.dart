import 'package:dartz/dartz.dart';
import 'package:medivault/core/utils/failure.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';

abstract class HistoryRepo {
  /// Fetches a map of specialtyId -> visitCount for all medical specialties.
  Future<Either<Failure, Map<String, int>>> getVisitCountsBySpecialty();

  /// Fetches all visits for a specific specialty, ordered newest first.
  Future<Either<Failure, List<VisitEntity>>> getVisitsBySpecialty(
      String specialtyId);

  /// Fetches detailed information for a single visit by its ID.
  Future<Either<Failure, VisitEntity>> getVisitDetails(String visitId);

  /// Updates an existing visit record.
  Future<Either<Failure, Unit>> updateVisit(VisitEntity visit);
}
