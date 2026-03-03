import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/import_export_file/data/data.dart';
import 'package:multi_catalog_system/features/import_export_file/domain/domain.dart';
import 'package:multi_catalog_system/features/import_export_file/presentation/bloc/import_file_bloc.dart';

void initImportFileModule() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<ImportFileRemoteDataSource>(
    () => ImportFileRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<ImportFileRepository>(
    () => ImportFileRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(
    () => ImportSingleFileUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => ImportCatalogFileUseCase(repository: getIt()),
  );

  getIt.registerFactory(
    () => ImportFileBloc(
      importSingleFileUseCase: getIt<ImportSingleFileUseCase>(),
      importCatalogFileUseCase: getIt<ImportCatalogFileUseCase>(),
    ),
  );
}
