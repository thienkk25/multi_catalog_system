import 'package:freezed_annotation/freezed_annotation.dart';

import 'identity_data_model.dart';

part 'identity_model.freezed.dart';
part 'identity_model.g.dart';

@freezed
abstract class IdentityModel with _$IdentityModel {
  const factory IdentityModel({
    @JsonKey(name: 'identity_id') required String identityId,

    required String id,

    @JsonKey(name: 'user_id') required String userId,

    @JsonKey(name: 'identity_data') IdentityDataModel? identityData,

    String? provider,

    @JsonKey(name: 'last_sign_in_at') DateTime? lastSignInAt,

    @JsonKey(name: 'created_at') DateTime? createdAt,

    @JsonKey(name: 'updated_at') DateTime? updatedAt,

    String? email,
  }) = _IdentityModel;

  factory IdentityModel.fromJson(Map<String, dynamic> json) =>
      _$IdentityModelFromJson(json);
}
