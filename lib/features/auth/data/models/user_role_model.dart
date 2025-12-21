import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_role_model.freezed.dart';
part 'user_role_model.g.dart';

@freezed
abstract class UserRoleModel with _$UserRoleModel {
  const factory UserRoleModel({required String code}) = _UserRoleModel;

  factory UserRoleModel.fromJson(Map<String, dynamic> json) =>
      _$UserRoleModelFromJson(json);
}
