import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/domain.dart';

import 'system_history_event.dart';
import 'system_history_state.dart';

class SystemHistoryBloc extends Bloc<SystemHistoryEvent, SystemHistoryState> {
  final GetAllSystemHistoryUseCase getAll;
  final GetByIdSystemHistoryUseCase getById;

  SystemHistoryBloc({required this.getAll, required this.getById})
    : super(const SystemHistoryState()) {
    on<SystemHistoryEvent>(_onEvent);
  }

  Future<void> _onEvent(
    SystemHistoryEvent event,
    Emitter<SystemHistoryState> emit,
  ) async {
    await event.map(
      getAll: (v) async {
        emit(state.copyWith(isLoading: true, error: null));

        final result = await getAll(search: v.search);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: _mapFailure(l))),
          (r) => emit(state.copyWith(isLoading: false, entries: r)),
        );
      },
      getById: (e) async {
        emit(state.copyWith(isLoading: true, error: null));

        final result = await getById(id: e.id);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: _mapFailure(l))),
          (r) {
            final updated = [
              for (final d in state.entries)
                if (d.id == r.id) r else d,
            ];
            emit(state.copyWith(isLoading: false, entries: updated));
          },
        );
      },
    );
  }

  String _mapFailure(Failure failure) {
    if (failure is ServerFailure) return failure.message;
    if (failure is CacheFailure) return failure.message;
    if (failure is UnexpectedFailure) return failure.message;
    return 'Unknown error';
  }
}
