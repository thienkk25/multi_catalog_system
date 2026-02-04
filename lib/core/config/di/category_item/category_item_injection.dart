import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/category_item/data/data.dart';
import 'package:multi_catalog_system/features/category_item/domain/domain.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';

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

  getIt.registerLazySingleton<CategoryItemVersionRemoteDataSource>(
    () => CategoryItemVersionRemoteDataSourceImpl(dio: getIt()),
  );
  getIt.registerLazySingleton<CategoryItemVersionRepository>(
    () => CategoryItemVersionRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(
    () => CreateCategoryItemVersionUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => UpdateCategoryItemVersionUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => DeleteCategoryItemVersionUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetByIdCategoryItemVersionUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetAllCategoryItemVersionUseCase(repository: getIt()),
  );

  getIt.registerLazySingleton(
    () => ApproveCategoryItemVersionUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => RejectCategoryItemVersionUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => DeleteByAdminCategoryItemVersionUseCase(repository: getIt()),
  );

  getIt.registerFactory(
    () => CategoryItemVersionBloc(
      getAll: getIt<GetAllCategoryItemVersionUseCase>(),
      getById: getIt<GetByIdCategoryItemVersionUseCase>(),
      createVersion: getIt<CreateCategoryItemVersionUseCase>(),
      updateVersion: getIt<UpdateCategoryItemVersionUseCase>(),
      deleteVersion: getIt<DeleteCategoryItemVersionUseCase>(),
      approveVersion: getIt<ApproveCategoryItemVersionUseCase>(),
      rejectVersion: getIt<RejectCategoryItemVersionUseCase>(),
      deleteByAdminVersion: getIt<DeleteByAdminCategoryItemVersionUseCase>(),
    ),
  );
}
