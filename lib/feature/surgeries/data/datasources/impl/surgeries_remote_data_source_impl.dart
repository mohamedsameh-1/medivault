import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import '../contract/surgeries_remote_data_source.dart';
import '../../model/surgery_model.dart';

@Injectable(as: SurgeriesRemoteDataSource)
class SurgeriesRemoteDataSourceImpl implements SurgeriesRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Connectivity _connectivity;

  SurgeriesRemoteDataSourceImpl(
    this._firebaseAuth,
    this._firestore,
    this._storage,
    this._connectivity,
  );

  String _getUserId() {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null || userId.isEmpty) {
      throw Exception('user_not_authenticated');
    }
    return userId;
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    final hasConnection =
        connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet);
    if (!hasConnection) {
      throw Exception('errors.no_internet_connection');
    }
  }

  @override
  Future<List<SurgeryModel>> getSurgeries() async {
    await _checkConnectivity();
    final userId = _getUserId();

    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('surgeries')
        .orderBy('surgeryDate', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => SurgeryModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<SurgeryModel> getSurgeryDetails(String surgeryId) async {
    await _checkConnectivity();
    final userId = _getUserId();

    final docSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('surgeries')
        .doc(surgeryId)
        .get();

    if (!docSnapshot.exists || docSnapshot.data() == null) {
      throw Exception('Surgery record not found.');
    }

    return SurgeryModel.fromFirestore(docSnapshot.data()!, docSnapshot.id);
  }

  @override
  Future<void> addSurgery(SurgeryModel surgery) async {
    await _checkConnectivity();
    final userId = _getUserId();

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('surgeries')
        .doc();

    final docId = docRef.id;
    final List<String> uploadedAttachments = [];

    for (final attachmentPath in surgery.attachments) {
      if (attachmentPath.startsWith('http://') ||
          attachmentPath.startsWith('https://')) {
        uploadedAttachments.add(attachmentPath);
      } else {
        final file = File(attachmentPath);
        if (await file.exists()) {
          final fileName = attachmentPath.split('/').last.split('\\').last;
          final storagePath =
              'users/$userId/surgeries/$docId/attachments/$fileName';
          final storageRef = _storage.ref().child(storagePath);
          final uploadTask = await storageRef.putFile(file);
          final downloadUrl = await uploadTask.ref.getDownloadURL();
          uploadedAttachments.add(downloadUrl);
        } else {
          uploadedAttachments.add(attachmentPath);
        }
      }
    }

    final finalModel = SurgeryModel(
      id: docId,
      surgeryName: surgery.surgeryName,
      specialty: surgery.specialty,
      surgeryDate: surgery.surgeryDate,
      doctorName: surgery.doctorName,
      hospitalName: surgery.hospitalName,
      diagnosis: surgery.diagnosis,
      // anesthesiaType: surgery.anesthesiaType,
      notes: surgery.notes,
      attachments: uploadedAttachments,
      createdAt: DateTime.now(),
    );

    await docRef.set(finalModel.toFirestore());
  }

  @override
  Future<void> updateSurgery(SurgeryModel surgery) async {
    await _checkConnectivity();
    final userId = _getUserId();

    if (surgery.id.isEmpty) {
      throw Exception('Surgery ID cannot be empty for update.');
    }

    final docId = surgery.id;
    final List<String> uploadedAttachments = [];

    for (final attachmentPath in surgery.attachments) {
      if (attachmentPath.startsWith('http://') ||
          attachmentPath.startsWith('https://')) {
        uploadedAttachments.add(attachmentPath);
      } else {
        final file = File(attachmentPath);
        if (await file.exists()) {
          final fileName = attachmentPath.split('/').last.split('\\').last;
          final storagePath =
              'users/$userId/surgeries/$docId/attachments/$fileName';
          final storageRef = _storage.ref().child(storagePath);
          final uploadTask = await storageRef.putFile(file);
          final downloadUrl = await uploadTask.ref.getDownloadURL();
          uploadedAttachments.add(downloadUrl);
        } else {
          uploadedAttachments.add(attachmentPath);
        }
      }
    }

    final finalModel = SurgeryModel(
      id: docId,
      surgeryName: surgery.surgeryName,
      specialty: surgery.specialty,
      surgeryDate: surgery.surgeryDate,
      doctorName: surgery.doctorName,
      hospitalName: surgery.hospitalName,
      diagnosis: surgery.diagnosis,
      // anesthesiaType: surgery.anesthesiaType,
      notes: surgery.notes,
      attachments: uploadedAttachments,
      createdAt: surgery.createdAt ?? DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('surgeries')
        .doc(docId)
        .set(finalModel.toFirestore(), SetOptions(merge: true));
  }

  @override
  Future<void> deleteSurgery(String surgeryId) async {
    await _checkConnectivity();
    final userId = _getUserId();

    if (surgeryId.isEmpty) {
      throw Exception('Surgery ID cannot be empty for deletion.');
    }

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('surgeries')
        .doc(surgeryId)
        .delete();
  }
}
