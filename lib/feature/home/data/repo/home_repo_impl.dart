import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/utils/failure.dart';
import '../../domain/entities/home_data_entity.dart';
import '../../domain/repo/home_repo.dart';
import '../datasources/contract/home_remote_data_source.dart';

@Injectable(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, HomeDataEntity>> getHomeData() async {
    try {
      final homeData = await _remoteDataSource.getHomeData();
      return Right(homeData);
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
