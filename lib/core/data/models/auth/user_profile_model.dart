import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/data/models/domain/domain_ref_model.dart';
import 'package:multi_catalog_system/core/data/models/role/role_model.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
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
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}
