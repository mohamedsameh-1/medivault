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
import 'package:medivault/core/services/visit_direct_share_service.dart'
    as _i628;
import 'package:medivault/core/services/visit_share_service.dart' as _i988;
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
import 'package:medivault/feature/history/data/datasources/contract/history_remote_data_source.dart'
    as _i311;
import 'package:medivault/feature/history/data/datasources/impl/history_remote_data_source_impl.dart'
    as _i58;
import 'package:medivault/feature/history/data/repo/history_repo_impl.dart'
    as _i320;
import 'package:medivault/feature/history/domain/repo/history_repo.dart'
    as _i889;
import 'package:medivault/feature/history/domain/usecase/get_visit_counts_use_case.dart'
    as _i194;
import 'package:medivault/feature/history/domain/usecase/get_visit_details_use_case.dart'
    as _i276;
import 'package:medivault/feature/history/domain/usecase/get_visits_by_specialty_use_case.dart'
    as _i161;
import 'package:medivault/feature/history/domain/usecase/update_visit_use_case.dart'
    as _i1012;
import 'package:medivault/feature/history/ui/viewmodel/history_cubit.dart'
    as _i286;
import 'package:medivault/feature/home/data/datasources/contract/home_remote_data_source.dart'
    as _i937;
import 'package:medivault/feature/home/data/datasources/impl/home_remote_data_source_impl.dart'
    as _i333;
import 'package:medivault/feature/home/data/repo/home_repo_impl.dart' as _i810;
import 'package:medivault/feature/home/domain/repo/home_repo.dart' as _i401;
import 'package:medivault/feature/home/domain/usecase/get_home_data_use_case.dart'
    as _i59;
import 'package:medivault/feature/home/ui/viewmodel/home_cubit.dart' as _i610;
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
import 'package:medivault/feature/surgeries/data/datasources/contract/surgeries_remote_data_source.dart'
    as _i819;
import 'package:medivault/feature/surgeries/data/datasources/impl/surgeries_remote_data_source_impl.dart'
    as _i78;
import 'package:medivault/feature/surgeries/data/repo/surgeries_repo_impl.dart'
    as _i189;
import 'package:medivault/feature/surgeries/domain/repo/surgeries_repo.dart'
    as _i91;
import 'package:medivault/feature/surgeries/domain/usecase/add_surgery_use_case.dart'
    as _i112;
import 'package:medivault/feature/surgeries/domain/usecase/delete_surgery_use_case.dart'
    as _i875;
import 'package:medivault/feature/surgeries/domain/usecase/get_surgeries_use_case.dart'
    as _i456;
import 'package:medivault/feature/surgeries/domain/usecase/get_surgery_details_use_case.dart'
    as _i247;
import 'package:medivault/feature/surgeries/domain/usecase/update_surgery_use_case.dart'
    as _i18;
import 'package:medivault/feature/surgeries/ui/viewmodel/surgeries_cubit.dart'
    as _i606;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i183.ImagePicker>(() => registerModule.imagePicker);
    gh.factory<_i628.VisitDirectShareService>(
      () => _i628.VisitDirectShareService(),
    );
    gh.factory<_i988.VisitShareService>(() => _i988.VisitShareService());
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
    gh.factory<_i937.HomeRemoteDataSource>(
      () => _i333.HomeRemoteDataSourceImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
        gh<_i895.Connectivity>(),
      ),
    );
    gh.factory<_i819.SurgeriesRemoteDataSource>(
      () => _i78.SurgeriesRemoteDataSourceImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
        gh<_i457.FirebaseStorage>(),
        gh<_i895.Connectivity>(),
      ),
    );
    gh.factory<_i311.HistoryRemoteDataSource>(
      () => _i58.HistoryRemoteDataSourceImpl(
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
    gh.factory<_i91.SurgeriesRepo>(
      () => _i189.SurgeriesRepoImpl(gh<_i819.SurgeriesRemoteDataSource>()),
    );
    gh.factory<_i537.AddVisitRepo>(
      () => _i74.AddVisitRepoImpl(gh<_i2.AddVisitRemoteDataSource>()),
    );
    gh.factory<_i889.HistoryRepo>(
      () => _i320.HistoryRepoImpl(gh<_i311.HistoryRemoteDataSource>()),
    );
    gh.factory<_i947.SetupRemoteDataSource>(
      () =>
          _i947.SetupRemoteDataSource(firestore: gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i112.AddSurgeryUseCase>(
      () => _i112.AddSurgeryUseCase(gh<_i91.SurgeriesRepo>()),
    );
    gh.factory<_i875.DeleteSurgeryUseCase>(
      () => _i875.DeleteSurgeryUseCase(gh<_i91.SurgeriesRepo>()),
    );
    gh.factory<_i456.GetSurgeriesUseCase>(
      () => _i456.GetSurgeriesUseCase(gh<_i91.SurgeriesRepo>()),
    );
    gh.factory<_i247.GetSurgeryDetailsUseCase>(
      () => _i247.GetSurgeryDetailsUseCase(gh<_i91.SurgeriesRepo>()),
    );
    gh.factory<_i18.UpdateSurgeryUseCase>(
      () => _i18.UpdateSurgeryUseCase(gh<_i91.SurgeriesRepo>()),
    );
    gh.factory<_i729.ProfileRepo>(
      () => _i363.ProfileRepoImpl(gh<_i929.ProfileDataSource>()),
    );
    gh.factory<_i401.HomeRepo>(
      () => _i810.HomeRepoImpl(gh<_i937.HomeRemoteDataSource>()),
    );
    gh.factory<_i532.AuthDataSource>(
      () => _i876.AuthDataSourceImpl(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        connectivity: gh<_i895.Connectivity>(),
      ),
    );
    gh.factory<_i606.SurgeriesCubit>(
      () => _i606.SurgeriesCubit(
        gh<_i456.GetSurgeriesUseCase>(),
        gh<_i247.GetSurgeryDetailsUseCase>(),
        gh<_i112.AddSurgeryUseCase>(),
        gh<_i18.UpdateSurgeryUseCase>(),
        gh<_i875.DeleteSurgeryUseCase>(),
      ),
    );
    gh.factory<_i993.SaveVisitUseCase>(
      () => _i993.SaveVisitUseCase(gh<_i537.AddVisitRepo>()),
    );
    gh.factory<_i59.GetHomeDataUseCase>(
      () => _i59.GetHomeDataUseCase(gh<_i401.HomeRepo>()),
    );
    gh.factory<_i608.AuthRepo>(
      () => _i595.AuthRepoImpl(gh<_i532.AuthDataSource>()),
    );
    gh.factory<_i194.GetVisitCountsUseCase>(
      () => _i194.GetVisitCountsUseCase(gh<_i889.HistoryRepo>()),
    );
    gh.factory<_i276.GetVisitDetailsUseCase>(
      () => _i276.GetVisitDetailsUseCase(gh<_i889.HistoryRepo>()),
    );
    gh.factory<_i161.GetVisitsBySpecialtyUseCase>(
      () => _i161.GetVisitsBySpecialtyUseCase(gh<_i889.HistoryRepo>()),
    );
    gh.factory<_i1012.UpdateVisitUseCase>(
      () => _i1012.UpdateVisitUseCase(gh<_i889.HistoryRepo>()),
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
    gh.factory<_i610.HomeCubit>(
      () => _i610.HomeCubit(gh<_i59.GetHomeDataUseCase>()),
    );
    gh.factory<_i752.VisitDetailsCubit>(
      () => _i752.VisitDetailsCubit(
        gh<_i993.SaveVisitUseCase>(),
        gh<_i183.ImagePicker>(),
      ),
    );
    gh.factory<_i286.HistoryCubit>(
      () => _i286.HistoryCubit(
        gh<_i194.GetVisitCountsUseCase>(),
        gh<_i161.GetVisitsBySpecialtyUseCase>(),
        gh<_i276.GetVisitDetailsUseCase>(),
        gh<_i1012.UpdateVisitUseCase>(),
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
