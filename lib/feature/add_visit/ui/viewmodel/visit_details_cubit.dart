import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/services/media_picker_service.dart';

import '../../domain/entities/visit_attachment_entity.dart';
import '../../domain/entities/visit_entity.dart';
import '../../domain/usecase/save_visit_use_case.dart';
import 'visit_details_state.dart';

@injectable
class VisitDetailsCubit extends Cubit<VisitDetailsState> {
  final SaveVisitUseCase _saveVisitUseCase;
  final MediaPickerService _mediaPickerService;

  final List<VisitAttachmentEntity> attachments = [];

  VisitDetailsCubit(
    this._saveVisitUseCase,
    this._mediaPickerService,
  ) : super(VisitDetailsInitialState());

  /// Captures a photo using the device camera
  Future<void> pickImageFromCamera() async {
    try {
      final File? file = await _mediaPickerService.pickImageFromCamera();

      if (isClosed || file == null) return;

      final int size = await file.length();
      final String rawName = file.path.split(RegExp(r'[\\/]')).last;
      final String fileName = rawName.isNotEmpty
          ? rawName
          : 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final attachment = VisitAttachmentEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fileName: fileName,
        fileType: 'image',
        fileSize: size,
        localPath: file.path,
      );

      attachments.add(attachment);
      emit(VisitDetailsAttachmentsChangedState(List.from(attachments)));
    } catch (e) {
      if (!isClosed) {
        emit(VisitDetailsValidationFailureState('failed_to_pick_image'));
      }
    }
  }

  /// Selects one or multiple images from the gallery
  Future<void> pickImagesFromGallery() async {
    try {
      final List<File> files =
          await _mediaPickerService.pickImagesFromGallery();

      if (isClosed || files.isEmpty) return;

      for (final file in files) {
        final int size = await file.length();
        final String rawName = file.path.split(RegExp(r'[\\/]')).last;
        final String fileName = rawName.isNotEmpty
            ? rawName
            : 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

        final attachment = VisitAttachmentEntity(
          id: '${DateTime.now().millisecondsSinceEpoch}_${attachments.length}',
          fileName: fileName,
          fileType: 'image',
          fileSize: size,
          localPath: file.path,
        );

        attachments.add(attachment);
      }

      emit(VisitDetailsAttachmentsChangedState(List.from(attachments)));
    } catch (e) {
      if (!isClosed) {
        emit(VisitDetailsValidationFailureState('failed_to_pick_image'));
      }
    }
  }

  /// Picks a document or image file using FilePicker
  Future<void> pickFile() async {
    try {
      final dynamic picker = FilePicker.platform;
      final dynamic result = await picker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );

      if (isClosed) return;

      if (result != null &&
          result.files != null &&
          (result.files as List).isNotEmpty) {
        final dynamic platformFile = (result.files as List).first;
        final String path = platformFile.path?.toString() ?? '';

        if (path.isNotEmpty) {
          final File file = File(path);
          final int size = await file.exists() ? await file.length() : 0;
          final String ext =
              platformFile.extension?.toString().toLowerCase() ?? '';
          final isPdf = ext == 'pdf';

          final attachment = VisitAttachmentEntity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            fileName: platformFile.name?.toString() ?? 'file',
            fileType: isPdf ? 'pdf' : 'image',
            fileSize: size,
            localPath: path,
          );

          attachments.add(attachment);
          emit(VisitDetailsAttachmentsChangedState(List.from(attachments)));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(VisitDetailsValidationFailureState('failed_to_pick_file'));
      }
    }
  }

  void removeAttachment(int index) {
    if (index >= 0 && index < attachments.length) {
      attachments.removeAt(index);
      emit(VisitDetailsAttachmentsChangedState(List.from(attachments)));
    }
  }

  Future<void> saveVisit({
    required String specialtyId,
    required DateTime visitDate,
    required String doctorName,
    required String clinicHospital,
    required String symptoms,
    required String diagnosis,
    String? advisoryNotes,
    String? prescriptions,
  }) async {
    if (state is VisitDetailsLoadingState) return;

    if (doctorName.trim().isEmpty) {
      emit(VisitDetailsValidationFailureState('doctor_name_required'));
      return;
    }

    if (clinicHospital.trim().isEmpty) {
      emit(VisitDetailsValidationFailureState('clinic_hospital_required'));
      return;
    }

    if (symptoms.trim().isEmpty) {
      emit(VisitDetailsValidationFailureState('symptoms_required'));
      return;
    }

    if (diagnosis.trim().isEmpty) {
      emit(VisitDetailsValidationFailureState('diagnosis_required'));
      return;
    }

    emit(VisitDetailsLoadingState());

    final visit = VisitEntity(
      specialtyId: specialtyId,
      visitDate: visitDate,
      doctorName: doctorName.trim(),
      clinicHospital: clinicHospital.trim(),
      symptoms: symptoms.trim(),
      diagnosis: diagnosis.trim(),
      advisoryNotes: advisoryNotes?.trim(),
      prescriptions: prescriptions?.trim(),
      createdAt: DateTime.now(),
      attachments: List.from(attachments),
    );

    final result = await _saveVisitUseCase(visit);

    if (isClosed) return;

    result.fold(
      (failure) => emit(VisitDetailsFailureState(failure)),
      (_) => emit(VisitDetailsSuccessState()),
    );
  }
}
