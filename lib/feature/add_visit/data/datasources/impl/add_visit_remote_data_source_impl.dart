import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/utils/failure.dart';

import '../../../domain/entities/visit_attachment_entity.dart';
import '../../../domain/entities/visit_entity.dart';
import '../../model/visit_model.dart';
import '../contract/add_visit_remote_data_source.dart';

@Injectable(as: AddVisitRemoteDataSource)
class AddVisitRemoteDataSourceImpl implements AddVisitRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Connectivity _connectivity;

  AddVisitRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    Connectivity? connectivity,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance,
       _connectivity = connectivity ?? Connectivity();

  @override
  Future<Either<Failure, Unit>> saveVisit(VisitEntity visit) async {
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

      // Create new visit document reference under users/{userId}/visits/
      final visitDocRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('visits')
          .doc();

      final visitId = visitDocRef.id;
      final List<VisitAttachmentEntity> uploadedAttachments = [];

      // Upload selected attachments to Firebase Storage
      for (final attachment in visit.attachments) {
        if (attachment.localPath != null && attachment.localPath!.isNotEmpty) {
          final file = File(attachment.localPath!);
          if (await file.exists()) {
            final storagePath =
                'users/$userId/visits/$visitId/attachments/${attachment.fileName}';
            final storageRef = _storage.ref().child(storagePath);
            final uploadTask = await storageRef.putFile(file);
            final downloadUrl = await uploadTask.ref.getDownloadURL();

            uploadedAttachments.add(
              VisitAttachmentEntity(
                id: attachment.id,
                fileName: attachment.fileName,
                fileUrl: downloadUrl,
                fileType: attachment.fileType,
                fileSize: attachment.fileSize,
                localPath: attachment.localPath,
              ),
            );
          }
        } else if (attachment.fileUrl != null &&
            attachment.fileUrl!.isNotEmpty) {
          uploadedAttachments.add(attachment);
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
        attachments: uploadedAttachments,
      );

      // Save visit document to Firestore
      await visitDocRef.set(visitModel.toFirestore());

      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(failureMessage: e.message ?? 'failed_to_save_visit'),
      );
    } catch (e) {
      return Left(ServerFailure(failureMessage: e.toString()));
    }
  }

  bool _hasInternetConnection(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet);
  }
}
