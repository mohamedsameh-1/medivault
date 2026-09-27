import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/utils/failure.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';
import '../repo/history_repo.dart';

@injectable
class UpdateVisitUseCase {
  final HistoryRepo _historyRepo;

  UpdateVisitUseCase(this._historyRepo);

  Future<Either<Failure, Unit>> call(VisitEntity visit) {
    return _historyRepo.updateVisit(visit);
  }
}
