import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/entities/system_history_entry.dart';

part 'system_history_state.freezed.dart';

@freezed
abstract class SystemHistoryState with _$SystemHistoryState {
  const factory SystemHistoryState({
    @Default(false) bool isLoading,
    String? error,
    @Default([]) List<SystemHistoryEntry> entries,
    SystemHistoryEntry? entry,
  }) = _SystemHistoryState;
}
