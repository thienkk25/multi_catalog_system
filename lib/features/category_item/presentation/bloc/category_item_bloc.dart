import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/domain/domain.dart';

import 'category_item_event.dart';
import 'category_item_state.dart';

class CategoryItemBloc extends Bloc<CategoryItemEvent, CategoryItemState> {
  final CreateCategoryItemUseCase create;
  final CreateManyCategoryItemUseCase createMany;
  final UpdateCategoryItemUseCase update;
  final DeleteCategoryItemUseCase delete;
  final GetByIdCategoryItemUseCase getById;
  final GetAllCategoryItemUseCase getAll;
  final UpsertManyCategoryItemUseCase upsertMany;

  CategoryItemBloc({
    required this.create,
    required this.createMany,
    required this.update,
    required this.delete,
    required this.getById,
    required this.getAll,
    required this.upsertMany,
  }) : super(const CategoryItemState()) {
    on<CategoryItemEvent>(_onEvent);
  }

  Future<void> _onEvent(
    CategoryItemEvent event,
    Emitter<CategoryItemState> emit,
  ) async {
    await event.map(
      getAll: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await getAll(search: e.search);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: _mapFailure(l))),
          (r) => emit(state.copyWith(isLoading: false, entries: r)),
        );
      },

      getById: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

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

      create: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await create(entry: e.entry);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: _mapFailure(l))),
          (r) => emit(
            state.copyWith(
              isLoading: false,
              entries: [r, ...state.entries],
              successMessage: 'Tạo thành công',
            ),
          ),
        );
      },

      createMany: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await createMany(entries: e.entries);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: _mapFailure(l))),
          (r) => emit(
            state.copyWith(
              isLoading: false,
              entries: [...r, ...state.entries],
              successMessage: 'Tạo thành công',
            ),
          ),
        );
      },

      update: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await update(entry: e.entry);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: _mapFailure(l))),
          (r) {
            final updated = [
              for (final d in state.entries)
                if (d.id == r.id) r else d,
            ];
            emit(
              state.copyWith(
                isLoading: false,
                entries: updated,
                successMessage: 'Cập nhật thành công',
              ),
            );
          },
        );
      },

      delete: (e) async {
        final previous = List<CategoryItemEntry>.from(state.entries);

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
          (l) => emit(state.copyWith(entries: previous, error: _mapFailure(l))),
          (_) {
            emit(state.copyWith(successMessage: 'Xóa thành công'));
          },
        );
      },

      upsertMany: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await upsertMany(entries: e.entries);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: _mapFailure(l))),
          (r) => emit(
            state.copyWith(
              isLoading: false,
              entries: r,
              successMessage: 'Cập nhật hoặc tạo thành công',
            ),
          ),
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
