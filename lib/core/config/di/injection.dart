import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/features.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerFactory(() => HomeBloc());
  // -------------------
  // 1. RemoteDataSource
  // -------------------
  getIt.registerLazySingleton<DomainRemoteDataSource>(
    () => DomainRemoteDataSourceImpl(dio: getIt()),
  );

  // -------------------
  // 2. Repository
  // -------------------
  getIt.registerLazySingleton<DomainRepository>(
    () => DomainRepositoryImpl(remoteDataSource: getIt()),
  );

  // -------------------
  // 3. UseCases
  // -------------------
  getIt.registerLazySingleton(() => CreateDomainUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateDomainUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteDomainUseCase(getIt()));
  getIt.registerLazySingleton(() => GetByIdDomainUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllDomainUseCase(getIt()));
  getIt.registerLazySingleton(() => UpsertManyDomainUseCase(getIt()));

  // -------------------
  // 4. Dio
  // -------------------
  getIt.registerLazySingleton(() => Dio());
}
