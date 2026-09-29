import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/failure.dart';
import '../entities/surgery_entity.dart';
import '../repo/surgeries_repo.dart';

@injectable
class GetSurgeriesUseCase {
  final SurgeriesRepo _repository;

  GetSurgeriesUseCase(this._repository);

  Future<Either<Failure, List<SurgeryEntity>>> call() {
    return _repository.getSurgeries();
  }
}
