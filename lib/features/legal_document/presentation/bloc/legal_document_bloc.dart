import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/formatter/map_failure_formatter.dart';
import 'package:multi_catalog_system/features/legal_document/domain/domain.dart';

import 'legal_document_event.dart';
import 'legal_document_state.dart';

class LegalDocumentBloc extends Bloc<LegalDocumentEvent, LegalDocumentState> {
  final CreateLegalDocumentUseCase create;
  final UpdateLegalDocumentUseCase update;
  final DeleteLegalDocumentUseCase delete;
  final GetByIdLegalDocumentUseCase getById;
  final GetAllLegalDocumentUseCase getAll;
  final GetAllLegalDocumentHasFileUseCase getAllHasFile;

  LegalDocumentBloc({
    required this.create,
    required this.update,
    required this.delete,
    required this.getById,
    required this.getAll,
    required this.getAllHasFile,
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
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            entry: null,
          ),
        );

        final result = await getAll(search: v.search);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(state.copyWith(isLoading: false, entries: r)),
        );
      },
      getAllHasFile: (v) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            entry: null,
          ),
        );

        final result = await getAllHasFile(search: v.search);
        if (emit.isDone) return;

        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(state.copyWith(isLoading: false, entries: r)),
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

        final result = await create(entry: e.entry, file: e.file);
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
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            entry: null,
          ),
        );

        final result = await update(entry: e.entry, file: e.file);
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
          (l) => emit(state.copyWith(entries: previous, error: mapFailure(l))),
          (_) {
            emit(state.copyWith(successMessage: 'Xóa thành công'));
          },
        );
      },

      toggleSelect: (e) {
        final selected = Set<String>.from(state.selectedIds);

        selected.contains(e.id) ? selected.remove(e.id) : selected.add(e.id);

        emit(state.copyWith(selectedIds: selected));
      },
    );
  }
}
