import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/failure.dart';
import '../entities/surgery_entity.dart';
import '../repo/surgeries_repo.dart';

@injectable
class GetSurgeryDetailsUseCase {
  final SurgeriesRepo _repository;

  GetSurgeryDetailsUseCase(this._repository);

  Future<Either<Failure, SurgeryEntity>> call(String surgeryId) {
    return _repository.getSurgeryDetails(surgeryId);
  }
}
