import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/auth/domain/domain.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;
  final AuthLoginUseCase authLoginUseCase;
  final AuthGetCurrentUserUseCase authGetCurrentUserUseCase;
  final AuthLogoutUseCase authLogoutUseCase;
  final AuthRefreshTokenUseCase authRefreshTokenUseCase;

  late final StreamSubscription<AuthStatus> _authSub;

  AuthBloc({
    required AuthRepository repo,
    required this.authLoginUseCase,
    required this.authGetCurrentUserUseCase,
    required this.authLogoutUseCase,
    required this.authRefreshTokenUseCase,
  }) : _repo = repo,
       super(const AuthState.initial()) {
    _authSub = _repo.authStatus.listen((status) {
      if (status == AuthStatus.unauthenticated) {
        add(const AuthEvent.logout());
      }
    });

    on<AuthEvent>((event, emit) async {
      await event.map(
        login: (e) async {
          emit(const AuthState.loading());

          final result = await authLoginUseCase(email: e.email, pass: e.pass);

          result.fold(
            (failure) => emit(_mapFailureToState(failure)),
            (user) => emit(AuthState.authenticated(entry: user)),
          );
        },

        getCurrentUser: (_) async {
          emit(const AuthState.loading());

          final result = await authGetCurrentUserUseCase();

          result.fold(
            (_) => emit(const AuthState.unauthenticated()),
            (user) => emit(AuthState.authenticated(entry: user)),
          );
        },

        refreshToken: (e) async {
          final result = await authRefreshTokenUseCase(
            refreshToken: e.refreshToken,
          );

          result.fold(
            (_) => emit(const AuthState.unauthenticated()),
            (_) => add(const AuthEvent.getCurrentUser()),
          );
        },

        logout: (_) async {
          await authLogoutUseCase();
          emit(const AuthState.unauthenticated());
        },

        checkAuthenticated: (_) async {
          add(const AuthEvent.getCurrentUser());
        },
      );
    });
  }

  @override
  Future<void> close() {
    _authSub.cancel();
    return super.close();
  }

  AuthState _mapFailureToState(Failure failure) {
    print(failure);
    if (failure is InvalidCredentialsFailure) {
      return const AuthState.error(
        message: 'Tài khoản email hoặc mật khẩu không chính xác',
      );
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
