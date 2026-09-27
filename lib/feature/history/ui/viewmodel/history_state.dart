import 'package:medivault/core/utils/failure.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';

abstract class HistoryState {}

/// Initial state
class HistoryInitialState extends HistoryState {}

/// Visit Counts States
class HistoryVisitCountsLoadingState extends HistoryState {}

class HistoryVisitCountsSuccessState extends HistoryState {
  final Map<String, int> visitCounts;
  HistoryVisitCountsSuccessState({required this.visitCounts});
}

/// Visits by Specialty States
class HistoryVisitsBySpecialtyLoadingState extends HistoryState {}

class HistoryVisitsBySpecialtySuccessState extends HistoryState {
  final List<VisitEntity> visits;
  HistoryVisitsBySpecialtySuccessState({required this.visits});
}

/// Single Visit Details States
class HistoryVisitDetailsLoadingState extends HistoryState {}

class HistoryVisitDetailsSuccessState extends HistoryState {
  final VisitEntity visit;
  HistoryVisitDetailsSuccessState({required this.visit});
}

/// Update Visit States
class UpdateVisitLoadingState extends HistoryState {}

class UpdateVisitSuccessState extends HistoryState {}

/// Error / Failure State
class HistoryFailureState extends HistoryState {
  final Failure failure;
  HistoryFailureState({required this.failure});
}
