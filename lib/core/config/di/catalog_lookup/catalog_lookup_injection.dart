import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/catalog_lookup/catalog_lookup.dart';

void initCatalogLookupModule() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<CatalogLookupRemoteDataSource>(
    () => CatalogLookupRemoteDataSourceImpl(dio: getIt()),
  );
  getIt.registerLazySingleton<CatalogLookupRepository>(
    () => CatalogLookupRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(
    () => GetCategoryGroupRefUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(() => SearchCatalogUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetDomainRefUseCase(repository: getIt()));

  getIt.registerFactory(
    () => CatalogLookupBloc(
      getCategoryGroupRefUseCase: getIt<GetCategoryGroupRefUseCase>(),
      searchCatalogUseCase: getIt<SearchCatalogUseCase>(),
      getDomainRefUseCase: getIt<GetDomainRefUseCase>(),
    ),
  );
}
