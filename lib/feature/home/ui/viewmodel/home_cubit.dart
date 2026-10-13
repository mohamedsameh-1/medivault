import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecase/get_home_data_use_case.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetHomeDataUseCase _getHomeDataUseCase;

  HomeCubit(this._getHomeDataUseCase) : super(HomeInitialState());

  Future<void> loadHomeData() async {
    emit(HomeLoadingState());
    final result = await _getHomeDataUseCase();
    if (isClosed) return;
    result.fold(
      (failure) => emit(HomeFailureState(failure: failure)),
      (data) => emit(HomeSuccessState(homeData: data)),
    );
  }
}
