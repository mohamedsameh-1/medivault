import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/failure.dart';
import '../../domain/entities/surgery_entity.dart';
import '../../domain/usecase/add_surgery_use_case.dart';
import '../../domain/usecase/delete_surgery_image_use_case.dart';
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
  final DeleteSurgeryImageUseCase _deleteSurgeryImageUseCase;

  List<SurgeryEntity> _surgeries = [];
  List<SurgeryEntity> get surgeries => _surgeries;

  SurgeriesCubit(
    this._getSurgeriesUseCase,
    this._getSurgeryDetailsUseCase,
    this._addSurgeryUseCase,
    this._updateSurgeryUseCase,
    this._deleteSurgeryUseCase,
    this._deleteSurgeryImageUseCase,
  ) : super(SurgeriesInitialState());

  /// Fetches all surgery records for current authenticated user
  Future<void> fetchSurgeries() async {
    emit(GetSurgeriesLoadingState());
    final result = await _getSurgeriesUseCase();
    if (isClosed) return;
    result.fold((failure) => emit(GetSurgeriesFailureState(failure: failure)), (
      surgeriesList,
    ) {
      _surgeries = List.from(surgeriesList);
      if (_surgeries.isEmpty) {
        emit(GetSurgeriesEmptyState());
      } else {
        emit(GetSurgeriesSuccessState(surgeries: _surgeries));
      }
    });
  }

  /// Fetches details for a single surgery record
  // Future<void> fetchSurgeryDetails(String surgeryId) async {
  //   final result = await _getSurgeryDetailsUseCase(surgeryId);
  //   if (isClosed) return;
  //   result.fold(
  //     (failure) => emit(GetSurgeriesFailureState(failure: failure)),
  //     (surgery) {
  //       final index = _surgeries.indexWhere((s) => s.id == surgery.id);
  //       if (index != -1) {
  //         _surgeries[index] = surgery;
  //       } else {
  //         _surgeries.add(surgery);
  //       }
  //     },
  //   );
  // }

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
    result.fold((failure) => emit(EditSurgeryFailureState(failure: failure)), (
      _,
    ) {
      final index = _surgeries.indexWhere((s) => s.id == surgery.id);
      if (index != -1) {
        _surgeries[index] = surgery;
      }
      emit(EditSurgerySuccessState(updatedSurgery: surgery));
    });
  }

  /// Deletes a surgery record by ID
  Future<void> deleteSurgery(String surgeryId) async {
    emit(DeleteSurgeryLoadingState());
    final result = await _deleteSurgeryUseCase(surgeryId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(DeleteSurgeryFailureState(failure: failure)),
      (_) {
        _surgeries.removeWhere((s) => s.id == surgeryId);
        emit(DeleteSurgerySuccessState(deletedId: surgeryId));
      },
    );
  }

  /// Deletes a specific image attachment from Supabase Storage and Firestore
  Future<void> deleteSurgeryImage({
    required String surgeryId,
    required String storagePath,
  }) async {
    emit(DeleteSurgeryImageLoadingState(storagePath: storagePath));
    final result = await _deleteSurgeryImageUseCase(
      surgeryId: surgeryId,
      storagePath: storagePath,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(DeleteSurgeryFailureState(failure: failure)),
      (_) {
        final index = _surgeries.indexWhere((s) => s.id == surgeryId);
        if (index != -1) {
          final current = _surgeries[index];
          final updatedAttachments = current.attachments
              .where((a) => a.fileUrl != storagePath && a.id != storagePath)
              .toList();
          final updatedImagePaths = current.imagePaths
              .where((p) => p != storagePath)
              .toList();

          _surgeries[index] = current.copyWith(
            attachments: updatedAttachments,
            imagePaths: updatedImagePaths,
          );
        }
        emit(DeleteSurgeryImageSuccessState(storagePath: storagePath));
      },
    );
  }
}
