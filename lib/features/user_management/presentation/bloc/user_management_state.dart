import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/user_management/domain/entities/user_management_entry.dart';

part 'user_management_state.freezed.dart';

@freezed
abstract class UserManagementState with _$UserManagementState {
  const factory UserManagementState({
    @Default(false) bool isLoading,
    @Default([]) List<UserManagementEntry> entries,
    String? error,
    String? successMessage,
  }) = _UserManagementState;
}
