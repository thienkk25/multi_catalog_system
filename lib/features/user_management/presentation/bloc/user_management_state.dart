import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';

part 'user_management_state.freezed.dart';

@freezed
abstract class UserManagementState with _$UserManagementState {
  const factory UserManagementState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,

    String? search,
    @Default(1) int page,
    @Default(20) int limit,
    String? sortBy,
    String? sort,
    @Default([]) List<UserEntry> entries,
    UserEntry? entry,
    String? error,
    String? successMessage,
  }) = _UserManagementState;
}
