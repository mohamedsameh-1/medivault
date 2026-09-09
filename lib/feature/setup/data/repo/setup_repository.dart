import 'package:injectable/injectable.dart';
import 'package:medivault/feature/setup/data/datasource/setup_remote_data_source.dart';
import 'package:medivault/feature/setup/data/model/setup_model.dart';

@injectable
class SetupRepository {
  final SetupRemoteDataSource remoteDataSource;

  SetupRepository({required this.remoteDataSource});

  Future<void> saveSetupData({
    required String userId,
    required SetupModel setupModel,
  }) async {
    await remoteDataSource.saveSetupData(
      userId: userId,
      setupModel: setupModel,
    );
  }

  Future<SetupModel> getSetupData({required String userId}) async {
    return await remoteDataSource.getSetupData(userId: userId);
  }
}
