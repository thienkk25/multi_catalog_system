import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/category_item/data/data.dart';
import 'package:multi_catalog_system/features/category_item/domain/domain.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_bloc.dart';

void initCategoryItemModule() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<CategoryItemRemoteDataSource>(
    () => CategoryItemRemoteDataSourceImpl(dio: getIt()),
  );
  getIt.registerLazySingleton<CategoryItemRepository>(
    () => CategoryItemRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(
    () => CreateCategoryItemUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => UpdateCategoryItemUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => DeleteCategoryItemUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetByIdCategoryItemUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetAllCategoryItemUseCase(repository: getIt()),
  );

  getIt.registerFactory(
    () => CategoryItemBloc(
      create: getIt<CreateCategoryItemUseCase>(),
      update: getIt<UpdateCategoryItemUseCase>(),
      delete: getIt<DeleteCategoryItemUseCase>(),
      getById: getIt<GetByIdCategoryItemUseCase>(),
      getAll: getIt<GetAllCategoryItemUseCase>(),
    ),
  );
}
