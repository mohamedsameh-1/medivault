import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/config/supabase_config.dart';
import 'package:medivault/core/services/supabase_storage_service.dart';
import 'package:medivault/core/utils/failure.dart';

import '../../../domain/entities/visit_attachment_entity.dart';
import '../../../domain/entities/visit_entity.dart';
import '../../model/visit_model.dart';
import '../contract/add_visit_remote_data_source.dart';

@Injectable(as: AddVisitRemoteDataSource)
class AddVisitRemoteDataSourceImpl implements AddVisitRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final SupabaseStorageService _storageService;
  final Connectivity _connectivity;

  AddVisitRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    required SupabaseStorageService storageService,
    Connectivity? connectivity,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _storageService = storageService,
       _connectivity = connectivity ?? Connectivity();

  @override
  Future<Either<Failure, Unit>> saveVisit(VisitEntity visit) async {
    final List<String> successfullyUploadedPaths = [];

    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (!_hasInternetConnection(connectivityResult)) {
        return Left(
          NetworkFailure(failureMessage: 'errors.no_internet_connection'),
        );
      }

      final userId = _firebaseAuth.currentUser?.uid;
      if (userId == null || userId.isEmpty) {
        return Left(ServerFailure(failureMessage: 'user_not_authenticated'));
      }

      // Pre-generate visit document reference under users/{userId}/visits/
      final visitDocRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('visits')
          .doc();

      final visitId = visitDocRef.id;
      final List<VisitAttachmentEntity> finalAttachments = [];
      final List<String> finalImagePaths = [];

      // Upload selected attachments to Supabase Storage
      for (final attachment in visit.attachments) {
        if (attachment.localPath != null && attachment.localPath!.isNotEmpty) {
          final file = File(attachment.localPath!);
          if (await file.exists()) {
            final safeName = attachment.fileName.replaceAll(
              RegExp(r'[^a-zA-Z0-9._-]'),
              '_',
            );
            final uniqueFileName =
                '${DateTime.now().millisecondsSinceEpoch}_$safeName';
            final storagePath = '$userId/$visitId/$uniqueFileName';

            // Upload to private Supabase Storage bucket
            await _storageService.uploadImage(
              bucket: SupabaseConfig.visitImagesBucket,
              path: storagePath,
              file: file,
            );

            successfullyUploadedPaths.add(storagePath);

            final isImage = attachment.fileType.toLowerCase() == 'image';
            if (isImage) {
              finalImagePaths.add(storagePath);
            }

            finalAttachments.add(
              VisitAttachmentEntity(
                id: attachment.id,
                fileName: attachment.fileName,
                fileUrl: storagePath, // Persist relative storage path
                fileType: attachment.fileType,
                fileSize: attachment.fileSize,
                localPath: attachment.localPath,
              ),
            );
          }
        } else if (attachment.fileUrl != null &&
            attachment.fileUrl!.isNotEmpty) {
          finalAttachments.add(attachment);
          if (attachment.fileType.toLowerCase() == 'image') {
            finalImagePaths.add(attachment.fileUrl!);
          }
        }
      }

      // Create visit model
      final visitModel = VisitModel(
        id: visitId,
        specialtyId: visit.specialtyId,
        visitDate: visit.visitDate,
        doctorName: visit.doctorName,
        clinicHospital: visit.clinicHospital,
        symptoms: visit.symptoms,
        diagnosis: visit.diagnosis,
        advisoryNotes: visit.advisoryNotes,
        prescriptions: visit.prescriptions,
        createdAt: DateTime.now(),
        attachments: finalAttachments,
        imagePaths: finalImagePaths,
      );

      // Save visit document to Firestore
      await visitDocRef.set(visitModel.toFirestore());

      return const Right(unit);
    } catch (e) {
      // Automatic cleanup: delete successfully uploaded files on failure
      if (successfullyUploadedPaths.isNotEmpty) {
        try {
          await _storageService.deleteImages(
            bucket: SupabaseConfig.visitImagesBucket,
            paths: successfullyUploadedPaths,
          );
        } catch (_) {
          // Best-effort cleanup
        }
      }

      if (e is FirebaseException) {
        return Left(
          ServerFailure(failureMessage: e.message ?? 'failed_to_save_visit'),
        );
      }
      return Left(ServerFailure(failureMessage: e.toString()));
    }
  }

  bool _hasInternetConnection(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet);
  }
}
