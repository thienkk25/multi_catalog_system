import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/features.dart';

import 'domain_management/domain_injection.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton(() => Dio());

  initDomainModule();

  getIt.registerFactory(() => HomeBloc());
}
