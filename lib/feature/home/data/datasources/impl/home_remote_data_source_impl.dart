import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/feature/add_visit/data/model/visit_model.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';
import 'package:medivault/feature/surgeries/data/model/surgery_model.dart';
import 'package:medivault/feature/surgeries/domain/entities/surgery_entity.dart';
import '../contract/home_remote_data_source.dart';
import '../../model/home_data_model.dart';

@Injectable(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final Connectivity _connectivity;

  HomeRemoteDataSourceImpl(
    this._firebaseAuth,
    this._firestore,
    this._connectivity,
  );

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

  String _getUserId() {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null || userId.isEmpty) {
      throw Exception('user_not_authenticated');
    }
    return userId;
  }

  @override
  Future<HomeDataModel> getHomeData() async {
    await _checkConnectivity();
    final userId = _getUserId();

    // 1. Fetch user profile name.
    // This is best-effort: a failure here must not prevent the rest of the
    // home data from loading, so the exception is caught locally. An empty
    // string is a safe sentinel — the greeting widget already falls back to
    // a generic greeting when userName is empty.
    String userName = '';
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc.data() != null) {
        final fullName = userDoc.data()!['fullName'] as String?;
        if (fullName != null && fullName.trim().isNotEmpty) {
          userName = fullName.trim().split(' ').first;
        }
      }
      // Fall back to Firebase Auth displayName when the Firestore profile
      // document does not contain a name.
      if (userName.isEmpty) {
        final displayName = _firebaseAuth.currentUser?.displayName;
        if (displayName != null && displayName.trim().isNotEmpty) {
          userName = displayName.trim().split(' ').first;
        }
      }
    } catch (_) {
      // Leave userName as empty string; the widget will show a generic greeting.
    }

    // 2. Fetch surgeries.
    // No local try-catch: FirebaseException propagates to HomeRepoImpl which
    // maps it to ServerFailure. An empty snapshot correctly returns [].
    final surgeriesSnap = await _firestore
        .collection('users')
        .doc(userId)
        .collection('surgeries')
        .orderBy('surgeryDate', descending: true)
        .get();

    final List<SurgeryEntity> allSurgeries = surgeriesSnap.docs
        .map((doc) => SurgeryModel.fromFirestore(doc.data(), doc.id))
        .toList();

    // 3. Fetch visits.
    // Same propagation strategy as surgeries.
    final visitsSnap = await _firestore
        .collection('users')
        .doc(userId)
        .collection('visits')
        .orderBy('visitDate', descending: true)
        .get();

    final List<VisitEntity> allVisits = visitsSnap.docs
        .map((doc) => VisitModel.fromFirestore(doc.data(), doc.id))
        .toList();

    return HomeDataModel.fromValues(
      userName: userName,
      recentSurgeries: allSurgeries.take(2).toList(),
      totalSurgeriesCount: allSurgeries.length,
      recentVisits: allVisits.take(2).toList(),
      totalVisitsCount: allVisits.length,
    );
  }
}
