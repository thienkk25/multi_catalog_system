import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/formatter/map_failure_formatter.dart';
import 'package:multi_catalog_system/features/import_export_file/domain/use_cases/export_catalog_file_use_case.dart';
import 'package:multi_catalog_system/features/import_export_file/domain/use_cases/export_single_file_use_case.dart';

import 'export_file_event.dart';
import 'export_file_state.dart';

class ExportFileBloc extends Bloc<ExportFileEvent, ExportFileState> {
  final ExportCatalogFileUseCase exportCatalogFileUseCase;
  final ExportSingleFileUseCase exportSingleFileUseCase;
  ExportFileBloc({
    required this.exportCatalogFileUseCase,
    required this.exportSingleFileUseCase,
  }) : super(const ExportFileState()) {
    on<ExportFileEvent>(_onEvent);
  }

  Future<void> _onEvent(
    ExportFileEvent event,
    Emitter<ExportFileState> emit,
  ) async {
    await event.when(
      exportCatalogFile: (format) async {
        emit(state.copyWith(isLoading: true, error: null, success: null));
        final result = await exportCatalogFileUseCase(format: format);
        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(
            state.copyWith(isLoading: false, success: 'Xuất tệp thành công'),
          ),
        );
      },
      exportSingleFile: (type, format) async {
        emit(state.copyWith(isLoading: true, error: null, success: null));
        final result = await exportSingleFileUseCase(
          type: type,
          format: format,
        );
        result.fold(
          (l) => emit(state.copyWith(isLoading: false, error: mapFailure(l))),
          (r) => emit(
            state.copyWith(isLoading: false, success: 'Xuất tệp thành công'),
          ),
        );
      },
    );
  }
}
