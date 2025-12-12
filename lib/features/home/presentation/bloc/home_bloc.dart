import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState.page(0, 'Tra cứu Danh mục')) {
    on<HomeEvent>((event, emit) {
      event.mapOrNull(
        changePage: (value) => emit(HomeState.page(value.index, value.title)),
      );
    });
  }
}
