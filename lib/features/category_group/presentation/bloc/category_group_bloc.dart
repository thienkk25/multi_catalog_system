import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';
import 'package:multi_catalog_system/features/category_group/domain/use_cases/create_category_group_use_case.dart';
import 'package:multi_catalog_system/features/category_group/domain/use_cases/create_many_category_group_use_case.dart';
import 'package:multi_catalog_system/features/category_group/domain/use_cases/delete_category_group_use_case.dart';
import 'package:multi_catalog_system/features/category_group/domain/use_cases/get_all_category_group_use_case.dart';
import 'package:multi_catalog_system/features/category_group/domain/use_cases/get_by_id_category_group_use_case.dart';
import 'package:multi_catalog_system/features/category_group/domain/use_cases/update_category_group_use_case.dart';
import 'package:multi_catalog_system/features/category_group/domain/use_cases/upsert_many_category_group_use_case.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_event.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_state.dart';

class CategoryGroupBloc extends Bloc<CategoryGroupEvent, CategoryGroupState> {
  final CreateCategoryGroupUseCase create;
  final CreateManyCategoryGroupUseCase createMany;
  final UpdateCategoryGroupUseCase update;
  final DeleteCategoryGroupUseCase delete;
  final GetByIdCategoryGroupUseCase getById;
  final GetAllCategoryGroupUseCase getAll;
  final UpsertManyDomainUseCase upsertMany;

  CategoryGroupBloc({
    required this.create,
    required this.createMany,
    required this.update,
    required this.delete,
    required this.getById,
    required this.getAll,
    required this.upsertMany,
  }) : super(const CategoryGroupState()) {
    on<CategoryGroupEvent>(_onEvent);
  }

  Future<void> _onEvent(
    CategoryGroupEvent event,
    Emitter<CategoryGroupState> emit,
  ) async {
    await event.map(
      getAll: (v) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await getAll(search: v.search);
        if (emit.isDone) return;

        result.fold(
          (f) => emit(state.copyWith(isLoading: false, error: _mapFailure(f))),
          (entities) =>
              emit(state.copyWith(isLoading: false, entities: entities)),
        );
      },

      getById: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await getById(e.id);
        if (emit.isDone) return;

        result.fold(
          (f) => emit(state.copyWith(isLoading: false, error: _mapFailure(f))),
          (domain) {
            final updated = [
              for (final d in state.entities)
                if (d.id == domain.id) domain else d,
            ];
            emit(state.copyWith(isLoading: false, entities: updated));
          },
        );
      },

      create: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await create(e.entry);
        if (emit.isDone) return;

        result.fold(
          (f) => emit(state.copyWith(isLoading: false, error: _mapFailure(f))),
          (domain) => emit(
            state.copyWith(
              isLoading: false,
              entities: [domain, ...state.entities],
              successMessage: 'Tạo lĩnh vực thành công',
            ),
          ),
        );
      },

      createMany: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await createMany(e.entities);
        if (emit.isDone) return;

        result.fold(
          (f) => emit(state.copyWith(isLoading: false, error: _mapFailure(f))),
          (entities) => emit(
            state.copyWith(
              isLoading: false,
              entities: [...entities, ...state.entities],
              successMessage: 'Tạo lĩnh vực thành công',
            ),
          ),
        );
      },

      update: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await update(e.entry);
        if (emit.isDone) return;

        result.fold(
          (f) => emit(state.copyWith(isLoading: false, error: _mapFailure(f))),
          (domain) {
            final updated = [
              for (final d in state.entities)
                if (d.id == domain.id) domain else d,
            ];
            emit(
              state.copyWith(
                isLoading: false,
                entities: updated,
                successMessage: 'Cập nhật lĩnh vực thành công',
              ),
            );
          },
        );
      },

      delete: (e) async {
        final previous = List<CategoryGroupEntry>.from(state.entities);

        emit(
          state.copyWith(
            entities: state.entities.where((d) => d.id != e.id).toList(),
            successMessage: null,
          ),
        );

        final result = await delete(e.id);
        if (emit.isDone) return;

        result.fold(
          (f) =>
              emit(state.copyWith(entities: previous, error: _mapFailure(f))),
          (_) {
            emit(state.copyWith(successMessage: 'Xóa thành công'));
          },
        );
      },

      upsertMany: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await upsertMany(e.entities);
        if (emit.isDone) return;

        result.fold(
          (f) => emit(state.copyWith(isLoading: false, error: _mapFailure(f))),
          (entities) => emit(
            state.copyWith(
              isLoading: false,
              entities: entities,
              successMessage: 'Cập nhật hoăc tạo lĩnh vực thành công',
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
