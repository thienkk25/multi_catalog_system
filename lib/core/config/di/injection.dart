import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/core/config/constants/app_constant.dart';
import 'package:multi_catalog_system/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:multi_catalog_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:multi_catalog_system/features/features.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/auth_injection.dart';
import 'auth/auth_interceptor.dart';
import 'domain_management/domain_injection.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  // Dio chính (có interceptor)
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: AppConstant.apiBaseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    ),
  );

  // Dio RIÊNG cho refresh (KHÔNG interceptor)
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: AppConstant.apiBaseUrl,
        validateStatus: (status) => status != null && status < 500,
      ),
    ),
    instanceName: 'refreshDio',
  );

  initAuthModule();

  // Interceptor
  getIt.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(
      dio: getIt<Dio>(),
      authLocal: getIt<AuthLocalDataSource>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt<Dio>().interceptors.add(getIt<AuthInterceptor>());

  initDomainModule();

  getIt.registerFactory(() => HomeBloc());
}
