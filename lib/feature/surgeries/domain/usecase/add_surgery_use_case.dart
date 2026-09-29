import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/failure.dart';
import '../entities/surgery_entity.dart';
import '../repo/surgeries_repo.dart';

@injectable
class AddSurgeryUseCase {
  final SurgeriesRepo _repository;

  AddSurgeryUseCase(this._repository);

  Future<Either<Failure, Unit>> call(SurgeryEntity surgery) {
    return _repository.addSurgery(surgery);
  }
}
