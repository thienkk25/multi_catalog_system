import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_file_state.freezed.dart';

@freezed
abstract class ImportFileState with _$ImportFileState {
  const factory ImportFileState({
    @Default(false) bool isLoading,
    String? error,
    String? success,
    Map<String, dynamic>? result,
  }) = _ImportFileState;
}
