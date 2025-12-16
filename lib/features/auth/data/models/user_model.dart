import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/auth/domain/entities/user_entry.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    @JsonKey(name: 'full_name') String? fullName,
    String? phone,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromEntry(UserEntry entry) => UserModel(
    id: entry.id,
    email: entry.email,
    fullName: entry.fullName,
    phone: entry.phone,
    status: entry.status,
    createdAt: entry.createdAt,
    updatedAt: entry.updatedAt,
  );
}

extension UserModelMapper on UserModel {
  UserEntry toEntry() => UserEntry(
    id: id,
    email: email,
    fullName: fullName,
    phone: phone,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
