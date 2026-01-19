import 'package:freezed_annotation/freezed_annotation.dart';

part 'identity_data_model.freezed.dart';
part 'identity_data_model.g.dart';

@freezed
abstract class IdentityDataModel with _$IdentityDataModel {
  const factory IdentityDataModel({
    String? email,

    @JsonKey(name: 'email_verified') bool? emailVerified,

    @JsonKey(name: 'phone_verified') bool? phoneVerified,

    String? sub,
  }) = _IdentityDataModel;

  factory IdentityDataModel.fromJson(Map<String, dynamic> json) =>
      _$IdentityDataModelFromJson(json);
}
