import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/domain.dart';

import 'api_key_event.dart';
import 'api_key_state.dart';

class ApiKeyBloc extends Bloc<ApiKeyEvent, ApiKeyState> {
  final CreateApiKeyUseCase create;
  final CreateManyApiKeyUseCase createMany;
  final UpdateApiKeyUseCase update;
  final DeleteApiKeyUseCase delete;
  final GetByIdApiKeyUseCase getById;
  final GetAllApiKeyUseCase getAll;
  final UpsertManyApiKeyUseCase upsertMany;

  ApiKeyBloc({
    required this.create,
    required this.createMany,
    required this.update,
    required this.delete,
    required this.getById,
    required this.getAll,
    required this.upsertMany,
  }) : super(const ApiKeyState()) {
    on<ApiKeyEvent>(_onEvent);
  }

  Future<void> _onEvent(ApiKeyEvent event, Emitter<ApiKeyState> emit) async {
    await event.map(
      getAll: (v) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            createdEntry: null,
          ),
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
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            createdEntry: null,
          ),
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
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            createdEntry: null,
          ),
        );

        final result = await create(e.entry);
        if (emit.isDone) return;

        result.fold(
          (f) => emit(state.copyWith(isLoading: false, error: _mapFailure(f))),
          (domain) => emit(
            state.copyWith(
              isLoading: false,
              entities: [domain, ...state.entities],
              successMessage: 'Tạo thành công',
              createdEntry: domain,
            ),
          ),
        );
      },

      createMany: (e) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            createdEntry: null,
          ),
        );

        final result = await createMany(e.entities);
        if (emit.isDone) return;

        result.fold(
          (f) => emit(state.copyWith(isLoading: false, error: _mapFailure(f))),
          (entities) => emit(
            state.copyWith(
              isLoading: false,
              entities: [...entities, ...state.entities],
              successMessage: 'Tạo thành công',
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
            createdEntry: null,
          ),
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
                successMessage: 'Cập nhật thành công',
              ),
            );
          },
        );
      },

      delete: (e) async {
        final previous = List<ApiKeyEntry>.from(state.entities);

        emit(
          state.copyWith(
            entities: state.entities.where((d) => d.id != e.id).toList(),
            successMessage: null,
            error: null,
            createdEntry: null,
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
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            createdEntry: null,
          ),
        );

        final result = await upsertMany(e.entities);
        if (emit.isDone) return;

        result.fold(
          (f) => emit(state.copyWith(isLoading: false, error: _mapFailure(f))),
          (entities) => emit(
            state.copyWith(
              isLoading: false,
              entities: entities,
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
