import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/failure.dart';
import '../../domain/entities/visit_entity.dart';
import '../../domain/repo/add_visit_repo.dart';
import '../datasources/contract/add_visit_remote_data_source.dart';

@Injectable(as: AddVisitRepo)
class AddVisitRepoImpl implements AddVisitRepo {
  final AddVisitRemoteDataSource _remoteDataSource;

  AddVisitRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Unit>> saveVisit(VisitEntity visit) {
    return _remoteDataSource.saveVisit(visit);
  }
}
