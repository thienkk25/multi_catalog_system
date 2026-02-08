import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entities/api_key_entry.dart';

part 'api_key_state.freezed.dart';

@freezed
abstract class ApiKeyState with _$ApiKeyState {
  const factory ApiKeyState({
    @Default(false) bool isLoading,
    @Default([]) List<ApiKeyEntry> entries,
    ApiKeyEntry? entry,
    String? error,
    String? successMessage,
    ApiKeyEntry? createdEntry,
  }) = _ApiKeyState;
}
