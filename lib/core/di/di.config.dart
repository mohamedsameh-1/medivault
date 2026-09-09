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
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:medivault/core/di/register_module.dart' as _i33;
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
    gh.singleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.singleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.singleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.factory<_i947.SetupRemoteDataSource>(
      () =>
          _i947.SetupRemoteDataSource(firestore: gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i532.AuthDataSource>(
      () => _i876.AuthDataSourceImpl(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        connectivity: gh<_i895.Connectivity>(),
      ),
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
    gh.factory<_i477.RegisterCubit>(
      () => _i477.RegisterCubit(gh<_i385.RegisterUseCase>()),
    );
    gh.factory<_i114.LoginCubit>(
      () => _i114.LoginCubit(gh<_i313.LoginUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i33.RegisterModule {}
