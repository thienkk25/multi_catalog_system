import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_metadata_model.dart';
import 'identity_model.dart';
import 'user_metadata_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String aud,
    required String role,
    required String email,

    @JsonKey(name: 'email_confirmed_at') DateTime? emailConfirmedAt,

    String? phone,

    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,

    @JsonKey(name: 'last_sign_in_at') DateTime? lastSignInAt,

    @JsonKey(name: 'app_metadata') AppMetadataModel? appMetadata,

    @JsonKey(name: 'user_metadata') UserMetadataModel? userMetadata,

    List<IdentityModel>? identities,

    @JsonKey(name: 'created_at') DateTime? createdAt,

    @JsonKey(name: 'updated_at') DateTime? updatedAt,

    @JsonKey(name: 'is_anonymous') required bool isAnonymous,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
