import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/utils/failure.dart';
import 'package:medivault/feature/add_visit/data/model/visit_model.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';
import '../../domain/repo/history_repo.dart';
import '../datasources/contract/history_remote_data_source.dart';

@Injectable(as: HistoryRepo)
class HistoryRepoImpl implements HistoryRepo {
  final HistoryRemoteDataSource _remoteDataSource;

  HistoryRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, int>>> getVisitCountsBySpecialty() async {
    try {
      final counts = await _remoteDataSource.getVisitCountsBySpecialty();
      return Right(counts);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(failureMessage: e.message ?? e.toString()));
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      if (message == 'errors.no_internet_connection') {
        return Left(NetworkFailure(failureMessage: message));
      }
      return Left(ServerFailure(failureMessage: message));
    }
  }

  @override
  Future<Either<Failure, List<VisitEntity>>> getVisitsBySpecialty(
      String specialtyId) async {
    try {
      final visits =
          await _remoteDataSource.getVisitsBySpecialty(specialtyId);
      return Right(visits);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(failureMessage: e.message ?? e.toString()));
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      if (message == 'errors.no_internet_connection') {
        return Left(NetworkFailure(failureMessage: message));
      }
      return Left(ServerFailure(failureMessage: message));
    }
  }

  @override
  Future<Either<Failure, VisitEntity>> getVisitDetails(String visitId) async {
    try {
      final visit = await _remoteDataSource.getVisitDetails(visitId);
      return Right(visit);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(failureMessage: e.message ?? e.toString()));
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      if (message == 'errors.no_internet_connection') {
        return Left(NetworkFailure(failureMessage: message));
      }
      return Left(ServerFailure(failureMessage: message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateVisit(VisitEntity visit) async {
    try {
      final visitModel = VisitModel.fromEntity(visit);
      await _remoteDataSource.updateVisit(visitModel);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(failureMessage: e.message ?? e.toString()));
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      if (message == 'errors.no_internet_connection') {
        return Left(NetworkFailure(failureMessage: message));
      }
      return Left(ServerFailure(failureMessage: message));
    }
  }
}
