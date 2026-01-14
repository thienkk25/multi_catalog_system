import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/profile/domain/domain.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ChangePasswordUseCase changePasswordUseCase;
  final GetMeUseCase getMeUseCase;
  final GetUserUseCase getUserUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc({
    required this.changePasswordUseCase,
    required this.getMeUseCase,
    required this.getUserUseCase,
    required this.updateProfileUseCase,
  }) : super(const ProfileState()) {
    on<ProfileEvent>(_onEvent);
  }

  Future<void> _onEvent(ProfileEvent event, Emitter<ProfileState> emit) async {
    await event.map(
      changePassword: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );
        final result = await changePasswordUseCase(newPassword: e.newPassword);
        result.fold(
          (l) {
            emit(
              state.copyWith(
                isLoading: false,
                error: _mapFailure(l),
                successMessage: null,
              ),
            );
          },
          (r) {
            emit(
              state.copyWith(
                isLoading: false,
                entry: r,
                error: null,
                successMessage: "Thay đổi mật khẩu thành công",
              ),
            );
          },
        );
      },
      getMe: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );
        final result = await getMeUseCase();
        result.fold(
          (l) {
            emit(
              state.copyWith(
                isLoading: false,
                error: _mapFailure(l),
                successMessage: null,
              ),
            );
          },
          (r) {
            emit(
              state.copyWith(
                isLoading: false,
                entry: r,
                error: null,
                successMessage: null,
              ),
            );
          },
        );
      },
      getUser: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );
        final result = await getUserUseCase();
        result.fold(
          (l) {
            emit(
              state.copyWith(
                isLoading: false,
                error: _mapFailure(l),
                successMessage: null,
              ),
            );
          },
          (r) {
            emit(
              state.copyWith(
                isLoading: false,
                entry: r,
                error: null,
                successMessage: null,
              ),
            );
          },
        );
      },
      updateProfile: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );
        final result = await updateProfileUseCase(entry: e.entry);
        result.fold(
          (l) {
            emit(
              state.copyWith(
                isLoading: false,
                error: _mapFailure(l),
                successMessage: null,
              ),
            );
          },
          (r) {
            emit(
              state.copyWith(
                isLoading: false,
                entry: r,
                error: null,
                successMessage: "Cập nhật thông tin thành công",
              ),
            );
          },
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
