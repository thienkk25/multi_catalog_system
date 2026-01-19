import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/profile/data/data.dart';
import 'package:multi_catalog_system/features/profile/domain/domain.dart';
import 'package:multi_catalog_system/features/profile/presentation/bloc/profile_bloc.dart';

void initProfileModule() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => GetProfileUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetMeUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateProfileUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => ChangePasswordUseCase(repository: getIt()));

  getIt.registerFactory(
    () => ProfileBloc(
      getProfileUseCase: getIt(),
      getMeUseCase: getIt(),
      updateProfileUseCase: getIt(),
      changePasswordUseCase: getIt(),
    ),
  );
}
