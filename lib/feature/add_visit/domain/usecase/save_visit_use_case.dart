import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/failure.dart';
import '../entities/visit_entity.dart';
import '../repo/add_visit_repo.dart';

@injectable
class SaveVisitUseCase {
  final AddVisitRepo _repository;

  SaveVisitUseCase(this._repository);

  Future<Either<Failure, Unit>> call(VisitEntity visit) {
    return _repository.saveVisit(visit);
  }
}
