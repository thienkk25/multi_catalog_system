import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/domain_management/domain/domain.dart';

import 'domain_management_event.dart';
import 'domain_management_state.dart';

class DomainManagementBloc
    extends Bloc<DomainManagementEvent, DomainManagementState> {
  final CreateDomainUseCase create;
  final CreateManyDomainUseCase createMany;
  final UpdateDomainUseCase update;
  final DeleteDomainUseCase delete;
  final GetByIdDomainUseCase getById;
  final GetAllDomainUseCase getAll;
  final UpsertManyDomainUseCase upsertMany;

  DomainManagementBloc({
    required this.create,
    required this.createMany,
    required this.update,
    required this.delete,
    required this.getById,
    required this.getAll,
    required this.upsertMany,
  }) : super(const DomainManagementState()) {
    on<DomainManagementEvent>(_onEvent);
  }

  Future<void> _onEvent(
    DomainManagementEvent event,
    Emitter<DomainManagementState> emit,
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
        final previous = List<DomainEntry>.from(state.entities);

        emit(
          state.copyWith(
            entities: state.entities.where((d) => d.id != e.id).toList(),
            successMessage: null,
            error: null,
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
              successMessage: 'Cập nhật hoặc tạo lĩnh vực thành công',
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
