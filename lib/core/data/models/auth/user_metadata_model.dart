import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_metadata_model.freezed.dart';
part 'user_metadata_model.g.dart';

@freezed
abstract class UserMetadataModel with _$UserMetadataModel {
  const factory UserMetadataModel({
    @JsonKey(name: 'email_verified') bool? emailVerified,

    @JsonKey(name: 'full_name') String? fullName,

    String? phone,
  }) = _UserMetadataModel;

  factory UserMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$UserMetadataModelFromJson(json);
}
