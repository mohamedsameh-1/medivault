import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/failure.dart';
import '../../domain/entities/surgery_entity.dart';
import '../../domain/usecase/add_surgery_use_case.dart';
import '../../domain/usecase/delete_surgery_use_case.dart';
import '../../domain/usecase/get_surgeries_use_case.dart';
import '../../domain/usecase/get_surgery_details_use_case.dart';
import '../../domain/usecase/update_surgery_use_case.dart';
import 'surgeries_state.dart';

@injectable
class SurgeriesCubit extends Cubit<SurgeriesState> {
  final GetSurgeriesUseCase _getSurgeriesUseCase;
  final GetSurgeryDetailsUseCase _getSurgeryDetailsUseCase;
  final AddSurgeryUseCase _addSurgeryUseCase;
  final UpdateSurgeryUseCase _updateSurgeryUseCase;
  final DeleteSurgeryUseCase _deleteSurgeryUseCase;

  SurgeriesCubit(
    this._getSurgeriesUseCase,
    this._getSurgeryDetailsUseCase,
    this._addSurgeryUseCase,
    this._updateSurgeryUseCase,
    this._deleteSurgeryUseCase,
  ) : super(SurgeriesInitialState());

  /// Fetches all surgery records for current authenticated user
  Future<void> fetchSurgeries() async {
    emit(GetSurgeriesLoadingState());
    final result = await _getSurgeriesUseCase();
    if (isClosed) return;
    result.fold((failure) => emit(GetSurgeriesFailureState(failure: failure)), (
      surgeries,
    ) {
      if (surgeries.isEmpty) {
        emit(GetSurgeriesEmptyState());
      } else {
        emit(GetSurgeriesSuccessState(surgeries: surgeries));
      }
    });
  }

  /// Adds a new surgery record after validation
  Future<void> addSurgery(SurgeryEntity surgery) async {
    if (surgery.surgeryName.trim().isEmpty) {
      emit(
        AddSurgeryFailureState(
          failure: ServerFailure(failureMessage: 'Please enter surgery name'),
        ),
      );
      return;
    }

    emit(AddSurgeryLoadingState());
    final result = await _addSurgeryUseCase(surgery);
    if (isClosed) return;
    result.fold(
      (failure) => emit(AddSurgeryFailureState(failure: failure)),
      (_) => emit(AddSurgerySuccessState()),
    );
  }

  /// Updates an existing surgery record
  Future<void> updateSurgery(SurgeryEntity surgery) async {
    if (surgery.surgeryName.trim().isEmpty) {
      emit(
        EditSurgeryFailureState(
          failure: ServerFailure(failureMessage: 'Please enter surgery name'),
        ),
      );
      return;
    }

    emit(EditSurgeryLoadingState());
    final result = await _updateSurgeryUseCase(surgery);
    if (isClosed) return;
    result.fold(
      (failure) => emit(EditSurgeryFailureState(failure: failure)),
      (_) => emit(EditSurgerySuccessState(updatedSurgery: surgery)),
    );
  }

  /// Deletes a surgery record by ID
  Future<void> deleteSurgery(String surgeryId) async {
    emit(DeleteSurgeryLoadingState());
    final result = await _deleteSurgeryUseCase(surgeryId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(DeleteSurgeryFailureState(failure: failure)),
      (_) => emit(DeleteSurgerySuccessState(deletedId: surgeryId)),
    );
  }
}
