import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_profile_entry.dart';
import 'package:multi_catalog_system/core/utils/formatter/map_failure_formatter.dart';
import 'package:multi_catalog_system/features/user_management/domain/domain.dart';

import 'user_management_event.dart';
import 'user_management_state.dart';

class UserManagementBloc
    extends Bloc<UserManagementEvent, UserManagementState> {
  final CreateUserManagementUseCase create;
  final UpdateUserManagementUseCase update;
  final DeleteUserManagementUseCase delete;
  final GetAllUserManagementUseCase getAll;
  final GetByIdUserManagementUseCase getById;
  final ActivateUserManagementUseCase activate;
  final DeactivateUserManagementUseCase deactivate;
  final GrantAccessUserManagementUseCase grantAccess;

  UserManagementBloc({
    required this.create,
    required this.update,
    required this.delete,
    required this.getAll,
    required this.getById,
    required this.activate,
    required this.deactivate,
    required this.grantAccess,
  }) : super(const UserManagementState()) {
    on<UserManagementEvent>(_onEvent);
  }

  Future<void> _onEvent(
    UserManagementEvent event,
    Emitter<UserManagementState> emit,
  ) async {
    await event.map(
      getAll: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await getAll(search: e.search);
        if (emit.isDone) return;
        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
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
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(state.copyWith(isLoading: false, entries: [r])),
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
        final previous = List<UserProfileEntry>.from(state.entries);

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
      activate: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await activate(id: e.id);
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
                successMessage: 'Mở khóa thành công',
              ),
            );
          },
        );
      },
      deactivate: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await deactivate(id: e.id);
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
                successMessage: 'Khóa thành công',
              ),
            );
          },
        );
      },
      grantAccess: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );

        final result = await grantAccess(entry: e.entry);
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
    );
  }
}
