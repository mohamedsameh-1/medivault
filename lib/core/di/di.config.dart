// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;
import 'package:medivault/core/di/register_module.dart' as _i33;
import 'package:medivault/feature/add_visit/data/datasources/contract/add_visit_remote_data_source.dart'
    as _i2;
import 'package:medivault/feature/add_visit/data/datasources/impl/add_visit_remote_data_source_impl.dart'
    as _i95;
import 'package:medivault/feature/add_visit/data/repo/add_visit_repo_impl.dart'
    as _i74;
import 'package:medivault/feature/add_visit/domain/repo/add_visit_repo.dart'
    as _i537;
import 'package:medivault/feature/add_visit/domain/usecase/save_visit_use_case.dart'
    as _i993;
import 'package:medivault/feature/add_visit/ui/viewmodel/visit_details_cubit.dart'
    as _i752;
import 'package:medivault/feature/auth/data/datasources/contract/auth_data_source.dart'
    as _i532;
import 'package:medivault/feature/auth/data/datasources/impl/auth_data_source_impl.dart'
    as _i876;
import 'package:medivault/feature/auth/data/repo/auth_repo_impl.dart' as _i595;
import 'package:medivault/feature/auth/domain/repo/auth_repo.dart' as _i608;
import 'package:medivault/feature/auth/domain/usecase/login_use_case.dart'
    as _i313;
import 'package:medivault/feature/auth/domain/usecase/register_use_case.dart'
    as _i385;
import 'package:medivault/feature/auth/ui/viewmodel/login/login_cubit.dart'
    as _i114;
import 'package:medivault/feature/auth/ui/viewmodel/register/register_cubit.dart'
    as _i477;
import 'package:medivault/feature/profile/data/datasources/contract/profile_data_source.dart'
    as _i929;
import 'package:medivault/feature/profile/data/datasources/impl/profile_data_source_impl.dart'
    as _i36;
import 'package:medivault/feature/profile/data/repo/profile_repo_impl.dart'
    as _i363;
import 'package:medivault/feature/profile/domain/repo/profile_repo.dart'
    as _i729;
import 'package:medivault/feature/profile/domain/usecase/delete_account_use_case.dart'
    as _i733;
import 'package:medivault/feature/profile/domain/usecase/get_profile_use_case.dart'
    as _i271;
import 'package:medivault/feature/profile/domain/usecase/logout_use_case.dart'
    as _i1041;
import 'package:medivault/feature/profile/domain/usecase/update_profile_use_case.dart'
    as _i1062;
import 'package:medivault/feature/profile/ui/viewmodel/profile_cubit.dart'
    as _i159;
import 'package:medivault/feature/setup/data/datasource/setup_remote_data_source.dart'
    as _i947;
import 'package:medivault/feature/setup/data/repo/setup_repository.dart'
    as _i165;
import 'package:medivault/feature/setup/presentation/viewmodel/setup_cubit.dart'
    as _i655;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i183.ImagePicker>(() => registerModule.imagePicker);
    gh.singleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.singleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.singleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.singleton<_i457.FirebaseStorage>(() => registerModule.storage);
    gh.factory<_i2.AddVisitRemoteDataSource>(
      () => _i95.AddVisitRemoteDataSourceImpl(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        firestore: gh<_i974.FirebaseFirestore>(),
        storage: gh<_i457.FirebaseStorage>(),
        connectivity: gh<_i895.Connectivity>(),
      ),
    );
    gh.factory<_i929.ProfileDataSource>(
      () => _i36.ProfileDataSourceImpl(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        firestore: gh<_i974.FirebaseFirestore>(),
        connectivity: gh<_i895.Connectivity>(),
      ),
    );
    gh.factory<_i537.AddVisitRepo>(
      () => _i74.AddVisitRepoImpl(gh<_i2.AddVisitRemoteDataSource>()),
    );
    gh.factory<_i947.SetupRemoteDataSource>(
      () =>
          _i947.SetupRemoteDataSource(firestore: gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i729.ProfileRepo>(
      () => _i363.ProfileRepoImpl(gh<_i929.ProfileDataSource>()),
    );
    gh.factory<_i532.AuthDataSource>(
      () => _i876.AuthDataSourceImpl(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        connectivity: gh<_i895.Connectivity>(),
      ),
    );
    gh.factory<_i993.SaveVisitUseCase>(
      () => _i993.SaveVisitUseCase(gh<_i537.AddVisitRepo>()),
    );
    gh.factory<_i608.AuthRepo>(
      () => _i595.AuthRepoImpl(gh<_i532.AuthDataSource>()),
    );
    gh.factory<_i165.SetupRepository>(
      () => _i165.SetupRepository(
        remoteDataSource: gh<_i947.SetupRemoteDataSource>(),
      ),
    );
    gh.factory<_i313.LoginUseCase>(
      () => _i313.LoginUseCase(gh<_i608.AuthRepo>()),
    );
    gh.factory<_i385.RegisterUseCase>(
      () => _i385.RegisterUseCase(gh<_i608.AuthRepo>()),
    );
    gh.factory<_i655.SetupCubit>(
      () => _i655.SetupCubit(
        gh<_i165.SetupRepository>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i733.DeleteAccountUseCase>(
      () => _i733.DeleteAccountUseCase(gh<_i729.ProfileRepo>()),
    );
    gh.factory<_i271.GetProfileUseCase>(
      () => _i271.GetProfileUseCase(gh<_i729.ProfileRepo>()),
    );
    gh.factory<_i1041.LogoutUseCase>(
      () => _i1041.LogoutUseCase(gh<_i729.ProfileRepo>()),
    );
    gh.factory<_i1062.UpdateProfileUseCase>(
      () => _i1062.UpdateProfileUseCase(gh<_i729.ProfileRepo>()),
    );
    gh.factory<_i752.VisitDetailsCubit>(
      () => _i752.VisitDetailsCubit(
        gh<_i993.SaveVisitUseCase>(),
        gh<_i183.ImagePicker>(),
      ),
    );
    gh.factory<_i477.RegisterCubit>(
      () => _i477.RegisterCubit(gh<_i385.RegisterUseCase>()),
    );
    gh.factory<_i159.ProfileCubit>(
      () => _i159.ProfileCubit(
        gh<_i271.GetProfileUseCase>(),
        gh<_i1062.UpdateProfileUseCase>(),
        gh<_i1041.LogoutUseCase>(),
        gh<_i733.DeleteAccountUseCase>(),
      ),
    );
    gh.factory<_i114.LoginCubit>(
      () => _i114.LoginCubit(gh<_i313.LoginUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i33.RegisterModule {}
