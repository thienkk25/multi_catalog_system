import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';

part 'profile_event.freezed.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.getProfile() = _GetProfile;
  const factory ProfileEvent.updateProfile({required UserEntry entry}) =
      _UpdateProfile;
  const factory ProfileEvent.changePassword({required String newPassword}) =
      _ChangePassword;
}
