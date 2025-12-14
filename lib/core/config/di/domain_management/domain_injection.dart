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

  getIt.registerLazySingleton(() => CreateDomainUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateManyDomainUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateDomainUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteDomainUseCase(getIt()));
  getIt.registerLazySingleton(() => GetByIdDomainUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllDomainUseCase(getIt()));
  getIt.registerLazySingleton(() => UpsertManyDomainUseCase(getIt()));

  getIt.registerFactory(
    () => DomainManagementBloc(
      createDomainUseCase: getIt<CreateDomainUseCase>(),
      updateDomainUseCase: getIt<UpdateDomainUseCase>(),
      deleteDomainUseCase: getIt<DeleteDomainUseCase>(),
      getByIdDomainUseCase: getIt<GetByIdDomainUseCase>(),
      getAllDomainUseCase: getIt<GetAllDomainUseCase>(),
      upsertManyDomainUseCase: getIt<UpsertManyDomainUseCase>(),
      createManyDomainUseCase: getIt<CreateManyDomainUseCase>(),
    ),
  );
}
