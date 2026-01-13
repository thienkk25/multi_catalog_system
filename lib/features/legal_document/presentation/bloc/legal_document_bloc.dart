import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/legal_document/domain/domain.dart';

import 'legal_document_event.dart';
import 'legal_document_state.dart';

class LegalDocumentBloc extends Bloc<LegalDocumentEvent, LegalDocumentState> {
  final CreateLegalDocumentUseCase create;
  final CreateManyLegalDocumentUseCase createMany;
  final UpdateLegalDocumentUseCase update;
  final DeleteLegalDocumentUseCase delete;
  final GetByIdLegalDocumentUseCase getById;
  final GetAllLegalDocumentUseCase getAll;
  final GetAllLegalDocumentHasFileUseCase getAllHasFile;
  final UpsertManyLegalDocumentUseCase upsertMany;

  LegalDocumentBloc({
    required this.create,
    required this.createMany,
    required this.update,
    required this.delete,
    required this.getById,
    required this.getAll,
    required this.getAllHasFile,
    required this.upsertMany,
  }) : super(const LegalDocumentState()) {
    on<LegalDocumentEvent>(_onEvent);
  }

  Future<void> _onEvent(
    LegalDocumentEvent event,
    Emitter<LegalDocumentState> emit,
  ) async {
    await event.map(
      getAll: (v) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await getAll(search: v.search);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: _mapFailure(l))),
          (r) => emit(state.copyWith(isLoading: false, entries: r)),
        );
      },
      getAllHasFile: (v) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await getAllHasFile(search: v.search);
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
            final updated = [r];
            emit(state.copyWith(isLoading: false, entries: updated));
          },
        );
      },

      create: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await create(entry: e.entry, file: e.file);
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

        final result = await update(entry: e.entry, file: e.file);
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
        final previous = List<LegalDocumentEntry>.from(state.entries);

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

      toggleSelect: (e) {
        final selected = Set<String>.from(state.selectedIds);

        selected.contains(e.id) ? selected.remove(e.id) : selected.add(e.id);

        emit(state.copyWith(selectedIds: selected));
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
