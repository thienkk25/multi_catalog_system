import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/formatter/map_failure_formatter.dart';
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
        emit(state.copyWith(isLoading: true, error: null, entry: null));

        final result = await getAll(search: v.search);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) =>
              emit(state.copyWith(isLoading: false, entries: r.entries ?? [])),
        );
      },
      loadMore: (_) async {
        if (state.isLoadingMore || !state.hasMore) return;

        emit(state.copyWith(isLoadingMore: true));

        final result = await getAll(page: state.page + 1, limit: state.limit);

        if (emit.isDone) return;

        result.fold(
          (l) =>
              emit(state.copyWith(isLoadingMore: false, error: mapFailure(l))),
          (r) => emit(
            state.copyWith(
              isLoadingMore: false,
              page: r.pagination?.page ?? 1,
              hasMore: r.pagination?.hasMore ?? false,
              entries: [...state.entries, ...r.entries ?? []],
            ),
          ),
        );
      },
      getById: (e) async {
        emit(state.copyWith(isLoading: true, error: null, entry: null));

        final result = await getById(id: e.id);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) {
            emit(state.copyWith(isLoading: false, entry: r));
          },
        );
      },
    );
  }
}
