import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/features/import_file/domain/use_cases/import_file_use_case.dart';

import 'import_file_event.dart';
import 'import_file_state.dart';

class ImportFileBloc extends Bloc<ImportFileEvent, ImportFileState> {
  final ImportFileUseCase importFileUseCase;

  ImportFileBloc({required this.importFileUseCase}) : super(ImportFileState()) {
    on<ImportFileEvent>(_onEvent);
  }

  Future<void> _onEvent(
    ImportFileEvent event,
    Emitter<ImportFileState> emit,
  ) async {
    await event.when(
      importFile: (file, table) async {
        emit(state.copyWith(isLoading: true, error: null, success: null));
        final result = await importFileUseCase(file: file, table: table);
        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: l)),
          (r) => emit(state.copyWith(isLoading: false, success: 'Thành công')),
        );
      },
    );
  }
}
