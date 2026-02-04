import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/formatter/map_failure_formatter.dart';
import 'package:multi_catalog_system/features/domain_management/domain/domain.dart';

import 'domain_management_event.dart';
import 'domain_management_state.dart';

class DomainManagementBloc
    extends Bloc<DomainManagementEvent, DomainManagementState> {
  final CreateDomainUseCase create;
  final UpdateDomainUseCase update;
  final DeleteDomainUseCase delete;
  final GetByIdDomainUseCase getById;
  final GetAllDomainUseCase getAll;

  DomainManagementBloc({
    required this.create,
    required this.update,
    required this.delete,
    required this.getById,
    required this.getAll,
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
          state.copyWith(
            isLoading: true,
            page: 1,
            hasMore: true,
            entries: [],
            error: null,
          ),
        );

        final result = await getAll(
          search: v.search,
          page: 1,
          limit: state.limit,
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
            ),
          ),
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
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await getById(id: e.id);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) {
            emit(state.copyWith(isLoading: false, entries: [r]));
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
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(
            state.copyWith(
              isLoading: false,
              entries: [r, ...state.entries],
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
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
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
        final previous = List<DomainEntry>.from(state.entries);

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
