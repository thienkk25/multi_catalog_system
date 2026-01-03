import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/system_history_management/data/data.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/domain.dart';
import 'package:multi_catalog_system/features/system_history_management/presentation/bloc/system_history_bloc.dart';

void initSystemHistoryManagementModule() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<SystemHistoryRemoteDataSource>(
    () => SystemHistoryRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<SystemHistoryRepository>(
    () => SystemHistoryRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(
    () => GetAllSystemHistoryUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetByIdSystemHistoryUseCase(repository: getIt()),
  );

  getIt.registerFactory(
    () => SystemHistoryBloc(
      getAll: getIt<GetAllSystemHistoryUseCase>(),
      getById: getIt<GetByIdSystemHistoryUseCase>(),
    ),
  );
}
