import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/utils/failure.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';
import '../repo/history_repo.dart';

@injectable
class GetVisitDetailsUseCase {
  final HistoryRepo _historyRepo;

  GetVisitDetailsUseCase(this._historyRepo);

  Future<Either<Failure, VisitEntity>> call(String visitId) {
    return _historyRepo.getVisitDetails(visitId);
  }
}
