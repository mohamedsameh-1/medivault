import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/failure.dart';
import '../../domain/entities/surgery_entity.dart';
import '../../domain/repo/surgeries_repo.dart';
import '../datasources/contract/surgeries_remote_data_source.dart';
import '../model/surgery_model.dart';

@Injectable(as: SurgeriesRepo)
class SurgeriesRepoImpl implements SurgeriesRepo {
  final SurgeriesRemoteDataSource _remoteDataSource;

  SurgeriesRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<SurgeryEntity>>> getSurgeries() async {
    try {
      final surgeries = await _remoteDataSource.getSurgeries();
      return Right(surgeries);
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
  Future<Either<Failure, SurgeryEntity>> getSurgeryDetails(
      String surgeryId) async {
    try {
      final surgery = await _remoteDataSource.getSurgeryDetails(surgeryId);
      return Right(surgery);
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
  Future<Either<Failure, Unit>> addSurgery(SurgeryEntity surgery) async {
    try {
      final model = SurgeryModel.fromEntity(surgery);
      await _remoteDataSource.addSurgery(model);
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

  @override
  Future<Either<Failure, Unit>> updateSurgery(SurgeryEntity surgery) async {
    try {
      final model = SurgeryModel.fromEntity(surgery);
      await _remoteDataSource.updateSurgery(model);
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

  @override
  Future<Either<Failure, Unit>> deleteSurgery(String surgeryId) async {
    try {
      await _remoteDataSource.deleteSurgery(surgeryId);
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
