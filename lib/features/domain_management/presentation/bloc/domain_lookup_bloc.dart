import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/formatter/map_failure_formatter.dart';
import 'package:multi_catalog_system/features/domain_management/domain/use_cases/get_domain_lookup_use_case.dart';

import 'domain_lookup_event.dart';
import 'domain_lookup_state.dart';

class DomainLookupBloc extends Bloc<DomainLookupEvent, DomainLookupState> {
  final GetDomainLookupUseCase lookup;

  DomainLookupBloc({required this.lookup}) : super(const DomainLookupState()) {
    on<DomainLookupEvent>(_onEvent);
  }

  Future<void> _onEvent(
    DomainLookupEvent event,
    Emitter<DomainLookupState> emit,
  ) async {
    await event.map(
      lookup: (v) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            page: 1,
            hasMore: true,
            entries: [],
          ),
        );
        final result = await lookup(page: state.page, limit: state.limit);
        if (emit.isDone) return;
        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) =>
              emit(state.copyWith(isLoading: false, entries: r.entries ?? [])),
        );
      },
      loadMore: (_) async {
        if (state.isLoadingMore || !state.hasMore) return;

        emit(state.copyWith(isLoadingMore: true, error: null));

        final result = await lookup(page: state.page + 1, limit: state.limit);

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
      selectedEntries: (e) {
        emit(state.copyWith(selectedEntries: e.entries));
      },
    );
  }
}
