import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/features/auth/domain/use_cases/auth_check_authenticated_use_case.dart';
import 'package:multi_catalog_system/features/auth/domain/use_cases/auth_get_current_user_use_case.dart';
import 'package:multi_catalog_system/features/auth/domain/use_cases/auth_login_use_case.dart';
import 'package:multi_catalog_system/features/auth/domain/use_cases/auth_logout_use_case.dart';
import 'package:multi_catalog_system/features/auth/domain/use_cases/auth_refresh_token_use_case.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_event.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthCheckAuthenticatedUseCase authCheckAuthenticatedUseCase;
  final AuthGetCurrentUserUseCase authGetCurrentUserUseCase;
  final AuthLoginUseCase authLoginUseCase;
  final AuthLogoutUseCase authLogoutUseCase;
  final AuthRefreshTokenUseCase authRefreshTokenUseCase;
  AuthBloc({
    required this.authCheckAuthenticatedUseCase,
    required this.authGetCurrentUserUseCase,
    required this.authLoginUseCase,
    required this.authLogoutUseCase,
    required this.authRefreshTokenUseCase,
  }) : super(const AuthState.initinal()) {
    on<AuthEvent>((event, emit) {
      event.map(
        login: (value) {},
        checkAuthenticated: (value) {},
        refreshToken: (value) {},
        logout: (value) {},
        getCurrentUser: (value) {},
      );
    });
  }
}
