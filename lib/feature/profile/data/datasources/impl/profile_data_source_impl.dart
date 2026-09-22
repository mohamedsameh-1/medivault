import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/utils/failure.dart';
import '../../model/profile_model.dart';
import '../contract/profile_data_source.dart';

@Injectable(as: ProfileDataSource)
class ProfileDataSourceImpl implements ProfileDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final Connectivity _connectivity;

  ProfileDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    Connectivity? connectivity,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _connectivity = connectivity ?? Connectivity();

  @override
  Future<Either<Failure, ProfileModel>> getProfileData() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (!_hasInternetConnection(connectivityResult)) {
        return Left(
          const NetworkFailure(failureMessage: 'errors.no_internet_connection'),
        );
      }

      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(
          const ServerFailure(failureMessage: 'User not logged in'),
        );
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data() ?? {};

      final profileModel = ProfileModel.fromJson({
        'uId': user.uid,
        'fullName': user.displayName ?? data['fullName'],
        'email': user.email ?? data['email'],
        'dateOfBirth': data['dateOfBirth'],
        'gender': data['gender'],
        'height': data['height'],
        'weight': data['weight'],
      });

      return Right(profileModel);
    } catch (e) {
      return Left(ServerFailure(failureMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfileData(ProfileModel profile) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (!_hasInternetConnection(connectivityResult)) {
        return Left(
          const NetworkFailure(failureMessage: 'errors.no_internet_connection'),
        );
      }

      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(
          const ServerFailure(failureMessage: 'User not logged in'),
        );
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(profile.toJson(), SetOptions(merge: true));

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(failureMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(failureMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (!_hasInternetConnection(connectivityResult)) {
        return Left(
          const NetworkFailure(failureMessage: 'errors.no_internet_connection'),
        );
      }

      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(
          const ServerFailure(failureMessage: 'User not logged in'),
        );
      }

      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(failureMessage: e.message ?? e.toString()));
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
