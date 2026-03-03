import 'package:freezed_annotation/freezed_annotation.dart';

part 'export_file_state.freezed.dart';

@freezed
abstract class ExportFileState with _$ExportFileState {
  const factory ExportFileState({
    @Default(false) bool isLoading,
    String? error,
    String? success,
  }) = _ExportFileState;
}
