import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/import_export_file/data/data.dart';
import 'package:multi_catalog_system/features/import_export_file/domain/domain.dart';
import 'package:multi_catalog_system/features/import_export_file/presentation/bloc/export_file_bloc.dart';

void initExportFileModule() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<ExportFileRemoteDataSource>(
    () => ExportFileRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<ExportFileRepository>(
    () => ExportFileRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(
    () => ExportSingleFileUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => ExportCatalogFileUseCase(repository: getIt()),
  );

  getIt.registerFactory(
    () => ExportFileBloc(
      exportSingleFileUseCase: getIt<ExportSingleFileUseCase>(),
      exportCatalogFileUseCase: getIt<ExportCatalogFileUseCase>(),
    ),
  );
}
