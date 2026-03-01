import 'package:multi_catalog_system/core/utils/formatter/map_failure_formatter.dart';
import 'package:multi_catalog_system/features/import_file/domain/use_cases/import_catalog_file_use_case.dart';
import 'package:multi_catalog_system/features/import_file/domain/use_cases/import_single_file_use_case.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'import_file_event.dart';
import 'import_file_state.dart';

class ImportFileBloc extends Bloc<ImportFileEvent, ImportFileState> {
  final ImportSingleFileUseCase importSingleFileUseCase;
  final ImportCatalogFileUseCase importCatalogFileUseCase;

  ImportFileBloc({
    required this.importSingleFileUseCase,
    required this.importCatalogFileUseCase,
  }) : super(ImportFileState()) {
    on<ImportFileEvent>(_onEvent);
  }

  Future<void> _onEvent(
    ImportFileEvent event,
    Emitter<ImportFileState> emit,
  ) async {
    await event.when(
      importSingleFile: (file, type) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            success: null,
            result: null,
          ),
        );
        final result = await importSingleFileUseCase(file: file, type: type);
        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(
            state.copyWith(
              isLoading: false,
              success: 'Nhập từ file thành công',
              result: r,
            ),
          ),
        );
      },
      importCatalogFile: (file) async {
        emit(
          state.copyWith(
            isLoading: true,
            error: null,
            success: null,
            result: null,
          ),
        );
        final result = await importCatalogFileUseCase(file: file);
        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(
            state.copyWith(
              isLoading: false,
              success: 'Nhập dữ liệu từ tệp thành công',
              result: r,
            ),
          ),
        );
      },
    );
  }
}
