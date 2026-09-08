// import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:injectable/injectable.dart';
// import '../../../../../core/utils/failure.dart';
// import '../../model/user_model.dart';
// import '../contract/auth_data_source.dart';

// @Injectable(as: AuthDataSource)
// class AuthDataSourceImpl implements AuthDataSource {
//   final FirebaseAuth _firebaseAuth;

//   AuthDataSourceImpl({FirebaseAuth? firebaseAuth})
//       : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

//   @override
//   Future<Either<Failure, UserModel>> loginWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       final user = userCredential.user;
//       final userModel = UserModel(
//         uId: user?.uid,
//         email: user?.email,
//         fullName: user?.displayName,
//       );

//       return Right(userModel);
//     } on FirebaseAuthException catch (e) {
//       return Left(ServerFailure(failureMessage: e.message ?? 'Login failed'));
//     } catch (e) {
//       return Left(ServerFailure(failureMessage: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, UserModel>> registerWithEmailAndPassword({
//     required String email,
//     required String password,
//     required String fullName,
//   }) async {
//     try {
//       final userCredential =
//           await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       final user = userCredential.user;
//       if (user != null) {
//         await user.updateDisplayName(fullName);
//       }

//       final userModel = UserModel(
//         uId: user?.uid,
//         email: user?.email,
//         fullName: fullName,
//       );

//       return Right(userModel);
//     } on FirebaseAuthException catch (e) {
//       return Left(
//         ServerFailure(failureMessage: e.message ?? 'Registration failed'),
//       );
//     } catch (e) {
//       return Left(ServerFailure(failureMessage: e.toString()));
//     }
//   }
// }

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/failure.dart';
import '../../model/user_model.dart';
import '../contract/auth_data_source.dart';

@Injectable(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final Connectivity _connectivity;

  AuthDataSourceImpl({FirebaseAuth? firebaseAuth, Connectivity? connectivity})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _connectivity = connectivity ?? Connectivity();

  @override
  Future<Either<Failure, UserModel>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (!_hasInternetConnection(connectivityResult)) {
        return Left(
          NetworkFailure(failureMessage: 'errors.no_internet_connection'),
        );
      }

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      final userModel = UserModel(
        uId: user?.uid,
        email: user?.email,
        fullName: user?.displayName,
      );

      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      return Left(
        ServerFailure(failureMessage: e.message ?? 'errors.login_failed'),
      );
    } catch (e) {
      return Left(ServerFailure(failureMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (!_hasInternetConnection(connectivityResult)) {
        return Left(
          NetworkFailure(failureMessage: 'errors.no_internet_connection'),
        );
      }

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(fullName);
      }

      final userModel = UserModel(
        uId: user?.uid,
        email: user?.email,
        fullName: fullName,
      );

      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      return Left(
        ServerFailure(
          failureMessage: e.message ?? 'errors.registration_failed',
        ),
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
