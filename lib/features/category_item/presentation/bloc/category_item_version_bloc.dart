import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/formatter/map_failure_formatter.dart';
import 'package:multi_catalog_system/features/category_item/domain/domain.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';

import 'category_item_version_event.dart';
import 'category_item_version_state.dart';

class CategoryItemVersionBloc
    extends Bloc<CategoryItemVersionEvent, CategoryItemVersionState> {
  final GetAllCategoryItemVersionUseCase getAll;
  final GetByIdCategoryItemVersionUseCase getById;
  final CreateCategoryItemVersionUseCase createVersion;
  final UpdateCategoryItemVersionUseCase updateVersion;
  final DeleteCategoryItemVersionUseCase deleteVersion;
  final ApproveCategoryItemVersionUseCase approveVersion;
  final RejectCategoryItemVersionUseCase rejectVersion;
  final DeleteOriginCategoryItemVersionUseCase deleteOrigin;

  CategoryItemVersionBloc({
    required this.getAll,
    required this.getById,
    required this.createVersion,
    required this.updateVersion,
    required this.deleteVersion,
    required this.approveVersion,
    required this.rejectVersion,
    required this.deleteOrigin,
  }) : super(const CategoryItemVersionState()) {
    on<CategoryItemVersionEvent>(_onEvent);
  }

  Future<void> _onEvent(
    CategoryItemVersionEvent event,
    Emitter<CategoryItemVersionState> emit,
  ) async {
    await event.map(
      getAll: (e) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            entry: null,
          ),
        );
        final result = await getAll(itemId: e.itemId, search: e.search);
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
          (r) => emit(state.copyWith(isLoading: false, entry: r)),
        );
      },
      createVersion: (e) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            entry: null,
          ),
        );

        final result = await createVersion(entry: e.entry);
        if (emit.isDone) return;
        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(
            state.copyWith(
              isLoading: false,
              successMessage: 'Gửi yêu cầu tạo thành công',
            ),
          ),
        );
      },
      updateVersion: (e) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            entry: null,
          ),
        );
        final result = await updateVersion(
          type: e.type,
          entry: e.entry,
          id: e.id,
        );
        if (emit.isDone) return;
        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(
            state.copyWith(isLoading: false, successMessage: 'Thành công'),
          ),
        );
      },
      deleteVersion: (e) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            entry: null,
          ),
        );
        final result = await deleteVersion(id: e.id);
        if (emit.isDone) return;
        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(
            state.copyWith(
              isLoading: false,
              successMessage: 'Gửi yêu cầu xóa thành công',
            ),
          ),
        );
      },
      approveVersion: (e) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            entry: null,
          ),
        );
        final result = await approveVersion(id: e.id);
        if (emit.isDone) return;
        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(
            state.copyWith(
              isLoading: false,
              successMessage: 'Phê duyệt thành công',
            ),
          ),
        );
      },
      rejectVersion: (e) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            successMessage: null,
            entry: null,
          ),
        );
        final result = await rejectVersion(
          id: e.id,
          rejectReason: e.rejectReason,
        );
        if (emit.isDone) return;
        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(
            state.copyWith(
              isLoading: false,
              successMessage: 'Từ chối thành công',
            ),
          ),
        );
      },
      delete: (e) async {
        final previous = List<CategoryItemVersionEntry>.from(state.entries);
        emit(
          state.copyWith(
            entries: state.entries.where((d) => d.id != e.id).toList(),
            error: null,
            successMessage: null,
            entry: null,
          ),
        );
        final result = await deleteOrigin(id: e.id);
        if (emit.isDone) return;
        result.fold(
          (l) => emit(state.copyWith(entries: previous, error: mapFailure(l))),
          (r) => emit(state.copyWith(successMessage: 'Xóa thành công')),
        );
      },
    );
  }
}
