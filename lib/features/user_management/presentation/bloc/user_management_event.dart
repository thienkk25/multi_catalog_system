import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/user_management/domain/entities/user_management_entry.dart';

part 'user_management_event.freezed.dart';

@freezed
class UserManagementEvent with _$UserManagementEvent {
  const factory UserManagementEvent.getAll({String? search}) = _GetAll;
  const factory UserManagementEvent.getById({required String id}) = _GetById;
  const factory UserManagementEvent.create({
    required UserManagementEntry entry,
  }) = _Create;
  const factory UserManagementEvent.update({
    required String id,
    required UserManagementEntry entry,
  }) = _Update;
  const factory UserManagementEvent.delete({required String id}) = _Delete;
  const factory UserManagementEvent.activate({required String id}) = _Activate;
  const factory UserManagementEvent.deactivate({required String id}) =
      _Deactivate;
  const factory UserManagementEvent.grantAccess({
    required UserManagementEntry entry,
  }) = _GrantAccess;
}
