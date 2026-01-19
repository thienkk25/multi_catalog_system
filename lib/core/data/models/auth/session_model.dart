import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_model.dart';
part 'session_model.freezed.dart';
part 'session_model.g.dart';

@freezed
abstract class SessionModel with _$SessionModel {
  const factory SessionModel({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'token_type') required String tokenType,
    @JsonKey(name: 'expires_in') required String expiresIn,
    @JsonKey(name: 'expires_at') required String expiresAt,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    required UserModel user,
    @JsonKey(name: 'weak_password') required String? weakPassword,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
}
