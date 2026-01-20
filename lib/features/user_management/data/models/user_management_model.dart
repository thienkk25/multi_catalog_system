import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/data/models/domain/domain_ref_model.dart';
import 'package:multi_catalog_system/core/data/models/role/role_model.dart';

part 'user_management_model.freezed.dart';
part 'user_management_model.g.dart';

@freezed
abstract class UserManagementModel with _$UserManagementModel {
  const factory UserManagementModel({
    required String id,
    required String email,
    @JsonKey(name: 'full_name') String? fullName,
    String? phone,
    required String status,
    RoleModel? role,
    List<DomainRefModel>? domains,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'last_sign_in_at') DateTime? lastSignInAt,
  }) = _UserManagementModel;

  factory UserManagementModel.fromJson(Map<String, dynamic> json) =>
      _$UserManagementModelFromJson(json);
}
