import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/category_group/category_group.dart';

void initCategoryGroupModule() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<CategoryGroupRemoteDataSource>(
    () => CategoryGroupRemoteDataSourceImpl(dio: getIt()),
  );
  getIt.registerLazySingleton<CategoryGroupRepository>(
    () => CategoryGroupRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(
    () => CreateCategoryGroupUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => UpdateCategoryGroupUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => DeleteCategoryGroupUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetByIdCategoryGroupUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetAllCategoryGroupUseCase(repository: getIt()),
  );

  getIt.registerLazySingleton(
    () => GetCategoryGroupLookupUseCase(repository: getIt()),
  );

  getIt.registerFactory(
    () => CategoryGroupBloc(
      create: getIt<CreateCategoryGroupUseCase>(),
      update: getIt<UpdateCategoryGroupUseCase>(),
      delete: getIt<DeleteCategoryGroupUseCase>(),
      getById: getIt<GetByIdCategoryGroupUseCase>(),
      getAll: getIt<GetAllCategoryGroupUseCase>(),
    ),
  );

  getIt.registerFactory(
    () =>
        CategoryGroupLookupBloc(lookup: getIt<GetCategoryGroupLookupUseCase>()),
  );
}
