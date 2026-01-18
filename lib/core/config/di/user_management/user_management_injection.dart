import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/user_management/data/data_sources/user_management_remote_data_source.dart';
import 'package:multi_catalog_system/features/user_management/data/repositories_impl/user_management_repository_impl.dart';
import 'package:multi_catalog_system/features/user_management/domain/domain.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_bloc.dart';

void initUserManagementModule() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<UserManagementRemoteDataSource>(
    () => UserManagementRemoteDataSourceImpl(dio: getIt()),
  );
  getIt.registerLazySingleton<UserManagementRepository>(
    () => UserManagementRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(
    () => CreateUserManagementUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => UpdateUserManagementUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => DeleteUserManagementUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetAllUserManagementUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetByIdUserManagementUseCase(repository: getIt()),
  );

  getIt.registerFactory(
    () => UserManagementBloc(
      create: getIt<CreateUserManagementUseCase>(),
      update: getIt<UpdateUserManagementUseCase>(),
      delete: getIt<DeleteUserManagementUseCase>(),
      getById: getIt<GetByIdUserManagementUseCase>(),
      getAll: getIt<GetAllUserManagementUseCase>(),
    ),
  );
}
