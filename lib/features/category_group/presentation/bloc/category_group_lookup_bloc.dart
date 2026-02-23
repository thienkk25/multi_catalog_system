import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/formatter/map_failure_formatter.dart';
import 'package:multi_catalog_system/features/category_group/domain/use_cases/get_category_group_lookup_use_case.dart';

import 'category_group_lookup_event.dart';
import 'category_group_lookup_state.dart';

class CategoryGroupLookupBloc
    extends Bloc<CategoryGroupLookupEvent, CategoryGroupLookupState> {
  final GetCategoryGroupLookupUseCase lookup;

  CategoryGroupLookupBloc({required this.lookup})
    : super(const CategoryGroupLookupState()) {
    on<CategoryGroupLookupEvent>(_onEvent);
  }

  Future<void> _onEvent(
    CategoryGroupLookupEvent event,
    Emitter<CategoryGroupLookupState> emit,
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
        final result = await lookup(
          domainId: v.domainId,
          page: state.page,
          limit: state.limit,
        );
        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(
            state.copyWith(
              isLoading: false,
              entries: r.entries ?? [],
              domainId: v.domainId,
            ),
          ),
        );
      },
      loadMore: (_) async {
        if (state.isLoadingMore || !state.hasMore) return;

        emit(state.copyWith(isLoadingMore: true, error: null));

        final result = await lookup(
          domainId: state.domainId!,
          page: state.page + 1,
          limit: state.limit,
        );

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
      selectEntries: (e) {
        emit(state.copyWith(selectedEntries: e.entries));
      },
    );
  }
}
