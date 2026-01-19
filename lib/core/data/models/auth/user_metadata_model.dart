import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_metadata_model.freezed.dart';
part 'user_metadata_model.g.dart';

@freezed
abstract class UserMetadataModel with _$UserMetadataModel {
  const factory UserMetadataModel({
    String? email,

    @JsonKey(name: 'email_verified') bool? emailVerified,

    @JsonKey(name: 'full_name') String? fullName,

    String? phone,

    @JsonKey(name: 'phone_verified') bool? phoneVerified,

    String? sub,
  }) = _UserMetadataModel;

  factory UserMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$UserMetadataModelFromJson(json);
}
