import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/visit_attachment_entity.dart';
import '../../domain/entities/visit_entity.dart';
import '../../domain/usecase/save_visit_use_case.dart';
import 'visit_details_state.dart';

@injectable
class VisitDetailsCubit extends Cubit<VisitDetailsState> {
  final SaveVisitUseCase _saveVisitUseCase;
  final ImagePicker _imagePicker;

  final List<VisitAttachmentEntity> attachments = [];

  VisitDetailsCubit(
    this._saveVisitUseCase,
    this._imagePicker,
  ) : super(VisitDetailsInitialState());

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (isClosed) return;

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        final int size = await file.length();
        final String fileName = pickedFile.name.isNotEmpty
            ? pickedFile.name
            : 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

        final attachment = VisitAttachmentEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          fileName: fileName,
          fileType: 'image',
          fileSize: size,
          localPath: pickedFile.path,
        );

        attachments.add(attachment);
        emit(VisitDetailsAttachmentsChangedState(List.from(attachments)));
      }
    } catch (e) {
      if (!isClosed) {
        emit(VisitDetailsValidationFailureState('failed_to_pick_image'));
      }
    }
  }

  Future<void> pickFile() async {
    try {
      final dynamic picker = FilePicker.platform;
      final dynamic result = await picker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );

      if (isClosed) return;

      if (result != null && result.files != null && (result.files as List).isNotEmpty) {
        final dynamic platformFile = (result.files as List).first;
        final String path = platformFile.path?.toString() ?? '';

        if (path.isNotEmpty) {
          final File file = File(path);
          final int size = await file.exists() ? await file.length() : 0;
          final String ext = platformFile.extension?.toString().toLowerCase() ?? '';
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
