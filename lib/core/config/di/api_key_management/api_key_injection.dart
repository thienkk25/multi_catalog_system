import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/api_key_management/data/data.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/domain.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/bloc/api_key_bloc.dart';

void initApiKeyModule() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<ApiKeyRemoteDataSource>(
    () => ApiKeyRemoteDataSourceImpl(dio: getIt()),
  );
  getIt.registerLazySingleton<ApiKeyRepository>(
    () => ApiKeyRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => CreateApiKeyUseCase(repository: getIt()));
  getIt.registerLazySingleton(
    () => CreateManyApiKeyUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(() => DeleteApiKeyUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetAllApiKeyUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetByIdApiKeyUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateApiKeyUseCase(repository: getIt()));
  getIt.registerLazySingleton(
    () => UpsertManyApiKeyUseCase(repository: getIt()),
  );

  getIt.registerFactory(
    () => ApiKeyBloc(
      create: getIt<CreateApiKeyUseCase>(),
      createMany: getIt<CreateManyApiKeyUseCase>(),
      update: getIt<UpdateApiKeyUseCase>(),
      delete: getIt<DeleteApiKeyUseCase>(),
      getById: getIt<GetByIdApiKeyUseCase>(),
      getAll: getIt<GetAllApiKeyUseCase>(),
      upsertMany: getIt<UpsertManyApiKeyUseCase>(),
    ),
  );
}
