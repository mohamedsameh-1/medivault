import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';
import '../../domain/usecase/delete_visit_image_use_case.dart';
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
  final DeleteVisitImageUseCase _deleteVisitImageUseCase;

  List<VisitEntity> _visits = [];
  List<VisitEntity> get visits => List.unmodifiable(_visits);

  HistoryCubit(
    this._getVisitCountsUseCase,
    this._getVisitsBySpecialtyUseCase,
    this._getVisitDetailsUseCase,
    this._updateVisitUseCase,
    this._deleteVisitUseCase,
    this._deleteVisitImageUseCase,
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

  /// Deletes a specific image attachment from Supabase Storage and Firestore
  Future<void> deleteVisitImage({
    required String visitId,
    required String storagePath,
  }) async {
    emit(DeleteVisitImageLoadingState(storagePath: storagePath));
    final result = await _deleteVisitImageUseCase(
      visitId: visitId,
      storagePath: storagePath,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(HistoryFailureState(failure: failure)),
      (_) {
        final visitIndex = _visits.indexWhere((v) => v.id == visitId);
        if (visitIndex != -1) {
          final current = _visits[visitIndex];
          final updatedAttachments = current.attachments
              .where((a) => a.fileUrl != storagePath && a.id != storagePath)
              .toList();
          final updatedImagePaths = current.imagePaths
              .where((p) => p != storagePath)
              .toList();
          _visits[visitIndex] = VisitEntity(
            id: current.id,
            specialtyId: current.specialtyId,
            visitDate: current.visitDate,
            doctorName: current.doctorName,
            clinicHospital: current.clinicHospital,
            symptoms: current.symptoms,
            diagnosis: current.diagnosis,
            advisoryNotes: current.advisoryNotes,
            prescriptions: current.prescriptions,
            createdAt: current.createdAt,
            attachments: updatedAttachments,
            imagePaths: updatedImagePaths,
          );
        }
        emit(DeleteVisitImageSuccessState(storagePath: storagePath));
      },
    );
  }
}
