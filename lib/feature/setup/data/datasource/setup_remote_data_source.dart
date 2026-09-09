import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/feature/setup/data/model/setup_model.dart';

@injectable
class SetupRemoteDataSource {
  final FirebaseFirestore firestore;

  SetupRemoteDataSource({required this.firestore});

  Future<void> saveSetupData({
    required String userId,
    required SetupModel setupModel,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .set(setupModel.toJson(), SetOptions(merge: true));
  }

  Future<SetupModel> getSetupData({required String userId}) async {
    final document = await firestore.collection('users').doc(userId).get();

    if (!document.exists || document.data() == null) {
      return const SetupModel();
    }

    return SetupModel.fromJson(document.data()!);
  }
}
