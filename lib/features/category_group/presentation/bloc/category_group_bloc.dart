import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/formatter/map_failure_formatter.dart';
import 'package:multi_catalog_system/features/category_group/domain/domain.dart';

import 'category_group_event.dart';
import 'category_group_state.dart';

class CategoryGroupBloc extends Bloc<CategoryGroupEvent, CategoryGroupState> {
  final CreateCategoryGroupUseCase create;
  final UpdateCategoryGroupUseCase update;
  final DeleteCategoryGroupUseCase delete;
  final GetByIdCategoryGroupUseCase getById;
  final GetAllCategoryGroupUseCase getAll;

  CategoryGroupBloc({
    required this.create,
    required this.update,
    required this.delete,
    required this.getById,
    required this.getAll,
  }) : super(const CategoryGroupState()) {
    on<CategoryGroupEvent>(_onEvent);
  }

  Future<void> _onEvent(
    CategoryGroupEvent event,
    Emitter<CategoryGroupState> emit,
  ) async {
    await event.map(
      getAll: (e) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            entry: null,
            page: 1,
            search: e.search,
            sortBy: e.sortBy,
            sort: e.sort,
            filter: e.filter,
            hasMore: true,
            entries: [],
          ),
        );

        final result = await getAll(
          search: e.search,
          page: 1,
          limit: state.limit,
          sortBy: e.sortBy,
          sort: e.sort,
          filter: e.filter,
        );
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(
            state.copyWith(
              isLoading: false,
              page: r.pagination?.page ?? 1,
              hasMore: r.pagination?.hasMore ?? false,
              entries: r.entries ?? [],
              search: e.search,
              sortBy: e.sortBy,
              sort: e.sort,
              filter: e.filter,
            ),
          ),
        );
      },
      loadMore: (_) async {
        if (state.isLoadingMore || !state.hasMore) return;

        emit(
          state.copyWith(
            isLoadingMore: true,
            error: null,
            successMessage: null,
          ),
        );

        final result = await getAll(
          search: state.search,
          page: state.page + 1,
          limit: state.limit,
          sortBy: state.sortBy,
          sort: state.sort,
          filter: state.filter,
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
      getById: (e) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            entry: null,
          ),
        );

        final result = await getById(id: e.id);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) {
            emit(state.copyWith(isLoading: false, entry: r));
          },
        );
      },

      create: (e) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            entry: null,
          ),
        );

        final result = await create(entry: e.entry);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(
            state.copyWith(
              isLoading: false,
              entries: [r, ...state.entries],
              successMessage: 'Tạo nhóm danh mục thành công',
            ),
          ),
        );
      },

      update: (e) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            entry: null,
          ),
        );

        final result = await update(entry: e.entry);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) {
            final index = state.entries.indexWhere((d) => d.id == r.id);

            if (index == -1 || state.entries[index] == r) return;

            final updated = List.of(state.entries);
            updated[index] = r;
            emit(
              state.copyWith(
                isLoading: false,
                entries: updated,
                successMessage: 'Cập nhật nhóm danh mục thành công',
              ),
            );
          },
        );
      },

      delete: (e) async {
        final previous = List<CategoryGroupEntry>.from(state.entries);

        emit(
          state.copyWith(
            entries: state.entries.where((d) => d.id != e.id).toList(),
            successMessage: null,
            error: null,
          ),
        );

        final result = await delete(id: e.id);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(entries: previous, error: mapFailure(l))),
          (_) {
            emit(state.copyWith(successMessage: 'Xóa thành công'));
          },
        );
      },
    );
  }
}
