import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/formatter/map_failure_formatter.dart';
import 'package:multi_catalog_system/features/profile/domain/domain.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ChangePasswordUseCase changePasswordUseCase;
  final GetMeUseCase getMeUseCase;
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc({
    required this.changePasswordUseCase,
    required this.getMeUseCase,
    required this.getProfileUseCase,
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
                error: mapFailure(l),
                successMessage: null,
              ),
            );
          },
          (r) {
            add(ProfileEvent.getProfile());
            emit(
              state.copyWith(successMessage: "Thay đổi mật khẩu thành công"),
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
                error: mapFailure(l),
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
      getProfile: (e) async {
        emit(
          state.copyWith(isLoading: true, error: null, successMessage: null),
        );
        final result = await getProfileUseCase();
        result.fold(
          (l) {
            emit(
              state.copyWith(
                isLoading: false,
                error: mapFailure(l),
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
                error: mapFailure(l),
                successMessage: null,
              ),
            );
          },
          (r) {
            add(ProfileEvent.getProfile());
            emit(
              state.copyWith(successMessage: "Cập nhật thông tin thành công"),
            );
          },
        );
      },
    );
  }
}
