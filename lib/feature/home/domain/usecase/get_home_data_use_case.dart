import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/utils/failure.dart';
import '../entities/home_data_entity.dart';
import '../repo/home_repo.dart';

@injectable
class GetHomeDataUseCase {
  final HomeRepo _repository;

  GetHomeDataUseCase(this._repository);

  Future<Either<Failure, HomeDataEntity>> call() {
    return _repository.getHomeData();
  }
}
