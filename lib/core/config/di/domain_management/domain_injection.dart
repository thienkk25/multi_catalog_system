import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/features.dart';

void initDomainModule() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<DomainRemoteDataSource>(
    () => DomainRemoteDataSourceImpl(dio: getIt()),
  );
  getIt.registerLazySingleton<DomainRepository>(
    () => DomainRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => CreateDomainUseCase(repository: getIt()));
  getIt.registerLazySingleton(
    () => CreateManyDomainUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(() => UpdateDomainUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => DeleteDomainUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetByIdDomainUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetAllDomainUseCase(repository: getIt()));
  getIt.registerLazySingleton(
    () => UpsertManyDomainUseCase(repository: getIt()),
  );

  getIt.registerFactory(
    () => DomainManagementBloc(
      create: getIt<CreateDomainUseCase>(),
      update: getIt<UpdateDomainUseCase>(),
      delete: getIt<DeleteDomainUseCase>(),
      getById: getIt<GetByIdDomainUseCase>(),
      getAll: getIt<GetAllDomainUseCase>(),
      upsertMany: getIt<UpsertManyDomainUseCase>(),
      createMany: getIt<CreateManyDomainUseCase>(),
    ),
  );
}
