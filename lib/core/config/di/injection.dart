import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/features.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/auth_injection.dart';
import 'domain_management/domain_injection.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton(() => Dio());

  initDomainModule();
  initAuthModule();

  getIt.registerFactory(() => HomeBloc());
}
