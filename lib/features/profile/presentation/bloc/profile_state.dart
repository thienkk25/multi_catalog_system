import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/profile/domain/entities/user_entry.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    UserEntry? entry,
    String? error,
    String? successMessage,
  }) = _ProfileState;
}
