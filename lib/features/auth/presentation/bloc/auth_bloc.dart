import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/auth/domain/use_cases/auth_get_current_user_use_case.dart';
import 'package:multi_catalog_system/features/auth/domain/use_cases/auth_login_use_case.dart';
import 'package:multi_catalog_system/features/auth/domain/use_cases/auth_logout_use_case.dart';
import 'package:multi_catalog_system/features/auth/domain/use_cases/auth_refresh_token_use_case.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_event.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthLoginUseCase authLoginUseCase;
  final AuthGetCurrentUserUseCase authGetCurrentUserUseCase;
  final AuthLogoutUseCase authLogoutUseCase;
  final AuthRefreshTokenUseCase authRefreshTokenUseCase;

  AuthBloc({
    required this.authLoginUseCase,
    required this.authGetCurrentUserUseCase,
    required this.authLogoutUseCase,
    required this.authRefreshTokenUseCase,
  }) : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.map(
        /// LOGIN
        login: (e) async {
          emit(const AuthState.loading());

          final result = await authLoginUseCase(email: e.email, pass: e.pass);

          result.fold(
            (failure) {
              emit(_mapFailureToState(failure));
            },
            (user) {
              emit(AuthState.authenticated(entry: user));
            },
          );
        },

        /// GET CURRENT USER (khi app mở)
        getCurrentUser: (e) async {
          emit(const AuthState.loading());

          final result = await authGetCurrentUserUseCase();

          result.fold(
            (_) {
              emit(const AuthState.unauthenticated());
            },
            (user) {
              emit(AuthState.authenticated(entry: user));
            },
          );
        },

        /// REFRESH TOKEN
        refreshToken: (e) async {
          final result = await authRefreshTokenUseCase(
            refreshToken: e.refreshToken,
          );

          result.fold(
            (_) {
              emit(const AuthState.unauthenticated());
            },
            (_) {
              add(const AuthEvent.getCurrentUser());
            },
          );
        },

        /// LOGOUT
        logout: (e) async {
          await authLogoutUseCase();
          emit(const AuthState.unauthenticated());
        },

        /// CHECK AUTH
        checkAuthenticated: (e) async {
          add(const AuthEvent.getCurrentUser());
        },
      );
    });
  }

  /// Map Failure → State
  AuthState _mapFailureToState(Failure failure) {
    if (failure is InvalidCredentialsFailure) {
      return const AuthState.error(message: 'Sai email hoặc mật khẩu');
    }
    if (failure is ServerFailure) {
      return const AuthState.error(message: 'Lỗi máy chủ');
    }
    if (failure is CacheFailure) {
      return const AuthState.unauthenticated();
    }
    return const AuthState.error(message: 'Đã xảy ra lỗi');
  }
}
