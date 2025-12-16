import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:multi_catalog_system/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:multi_catalog_system/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:multi_catalog_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:multi_catalog_system/features/auth/domain/use_cases/auth_check_authenticated_use_case.dart';
import 'package:multi_catalog_system/features/auth/domain/use_cases/auth_get_current_user_use_case.dart';
import 'package:multi_catalog_system/features/auth/domain/use_cases/auth_login_use_case.dart';
import 'package:multi_catalog_system/features/auth/domain/use_cases/auth_logout_use_case.dart';
import 'package:multi_catalog_system/features/auth/domain/use_cases/auth_refresh_token_use_case.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_bloc.dart';

void initAuthModule() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: getIt()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: getIt(),
      authLocalDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<AuthCheckAuthenticatedUseCase>(
    () => AuthCheckAuthenticatedUseCase(authRepository: getIt()),
  );
  getIt.registerLazySingleton<AuthGetCurrentUserUseCase>(
    () => AuthGetCurrentUserUseCase(authRepository: getIt()),
  );
  getIt.registerLazySingleton<AuthLoginUseCase>(
    () => AuthLoginUseCase(authRepository: getIt()),
  );
  getIt.registerLazySingleton<AuthLogoutUseCase>(
    () => AuthLogoutUseCase(authRepository: getIt()),
  );
  getIt.registerLazySingleton<AuthRefreshTokenUseCase>(
    () => AuthRefreshTokenUseCase(authRepository: getIt()),
  );

  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      authCheckAuthenticatedUseCase: getIt<AuthCheckAuthenticatedUseCase>(),
      authGetCurrentUserUseCase: getIt<AuthGetCurrentUserUseCase>(),
      authLoginUseCase: getIt<AuthLoginUseCase>(),
      authLogoutUseCase: getIt<AuthLogoutUseCase>(),
      authRefreshTokenUseCase: getIt<AuthRefreshTokenUseCase>(),
    ),
  );
}
