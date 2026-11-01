import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';
import '../../domain/usecase/get_visit_counts_use_case.dart';
import '../../domain/usecase/get_visit_details_use_case.dart';
import '../../domain/usecase/get_visits_by_specialty_use_case.dart';
import '../../domain/usecase/update_visit_use_case.dart';
import '../../domain/usecase/delete_visit_use_case.dart';
import 'history_state.dart';

@injectable
class HistoryCubit extends Cubit<HistoryState> {
  final GetVisitCountsUseCase _getVisitCountsUseCase;
  final GetVisitsBySpecialtyUseCase _getVisitsBySpecialtyUseCase;
  final GetVisitDetailsUseCase _getVisitDetailsUseCase;
  final UpdateVisitUseCase _updateVisitUseCase;
  final DeleteVisitUseCase _deleteVisitUseCase;

  List<VisitEntity> _visits = [];
  List<VisitEntity> get visits => List.unmodifiable(_visits);

  HistoryCubit(
    this._getVisitCountsUseCase,
    this._getVisitsBySpecialtyUseCase,
    this._getVisitDetailsUseCase,
    this._updateVisitUseCase,
    this._deleteVisitUseCase,
  ) : super(HistoryInitialState());

  /// Fetches visit counts grouped by specialty ID for History Home
  Future<void> loadVisitCounts() async {
    emit(HistoryVisitCountsLoadingState());
    final result = await _getVisitCountsUseCase();
    if (isClosed) return;
    result.fold(
      (failure) => emit(HistoryFailureState(failure: failure)),
      (counts) => emit(HistoryVisitCountsSuccessState(visitCounts: counts)),
    );
  }

  /// Fetches all visit records belonging to a selected specialty
  Future<void> loadVisitsBySpecialty(String specialtyId) async {
    emit(HistoryVisitsBySpecialtyLoadingState());
    final result = await _getVisitsBySpecialtyUseCase(specialtyId);
    if (isClosed) return;
    result.fold((failure) => emit(HistoryFailureState(failure: failure)), (
      visits,
    ) {
      _visits = List<VisitEntity>.from(visits);
      emit(
        HistoryVisitsBySpecialtySuccessState(
          visits: List.unmodifiable(_visits),
        ),
      );
    });
  }

  /// Removes a deleted visit record from the in-memory specialty list
  // void removeVisitFromList(String visitId) {
  //   _visits.removeWhere((v) => v.id == visitId);
  //   emit(HistoryVisitsBySpecialtySuccessState(
  //     visits: List.unmodifiable(_visits),
  //   ));
  // }

  /// Updates an existing visit record in the in-memory specialty list
  // void updateVisitInList(VisitEntity updatedVisit) {
  //   final index = _visits.indexWhere((v) => v.id == updatedVisit.id);
  //   if (index != -1) {
  //     _visits[index] = updatedVisit;
  //     emit(HistoryVisitsBySpecialtySuccessState(
  //       visits: List.unmodifiable(_visits),
  //     ));
  //   }
  // }

  /// Fetches full details for a single visit document ID
  Future<void> loadVisitDetails(String visitId) async {
    emit(HistoryVisitDetailsLoadingState());
    final result = await _getVisitDetailsUseCase(visitId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(HistoryFailureState(failure: failure)),
      (visit) => emit(HistoryVisitDetailsSuccessState(visit: visit)),
    );
  }

  /// Updates an existing visit record
  Future<void> updateVisitRecord(VisitEntity visit) async {
    emit(UpdateVisitLoadingState());
    final result = await _updateVisitUseCase(visit);
    if (isClosed) return;
    result.fold(
      (failure) => emit(HistoryFailureState(failure: failure)),
      (_) => emit(UpdateVisitSuccessState()),
    );
  }

  /// Permanently deletes a visit record by its ID
  Future<void> deleteVisitRecord(String visitId) async {
    emit(DeleteVisitLoadingState());
    final result = await _deleteVisitUseCase(visitId);
    if (isClosed) return;
    result.fold((failure) => emit(HistoryFailureState(failure: failure)), (_) {
      _visits.removeWhere((v) => v.id == visitId);
      emit(DeleteVisitSuccessState(deletedVisitId: visitId));
    });
  }
}
