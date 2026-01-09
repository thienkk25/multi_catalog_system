import 'package:get_it/get_it.dart';
import 'package:multi_catalog_system/features/legal_document/data/data.dart';
import 'package:multi_catalog_system/features/legal_document/domain/domain.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/document_file_cubit.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_bloc.dart';

void initLegalDocumentModule() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<LegalDocumentRemoteDataSource>(
    () => LegalDocumentRemoteDataSourceImpl(dio: getIt()),
  );
  getIt.registerLazySingleton<LegalDocumentRepository>(
    () => LegalDocumentRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(
    () => CreateLegalDocumentUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => CreateManyLegalDocumentUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => UpdateLegalDocumentUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => DeleteLegalDocumentUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetByIdLegalDocumentUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetAllLegalDocumentUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => UpsertManyLegalDocumentUseCase(repository: getIt()),
  );

  getIt.registerFactory(
    () => LegalDocumentBloc(
      create: getIt<CreateLegalDocumentUseCase>(),
      createMany: getIt<CreateManyLegalDocumentUseCase>(),
      update: getIt<UpdateLegalDocumentUseCase>(),
      delete: getIt<DeleteLegalDocumentUseCase>(),
      getById: getIt<GetByIdLegalDocumentUseCase>(),
      getAll: getIt<GetAllLegalDocumentUseCase>(),
      upsertMany: getIt<UpsertManyLegalDocumentUseCase>(),
    ),
  );

  getIt.registerFactory(() => DocumentFileCubit());
}
