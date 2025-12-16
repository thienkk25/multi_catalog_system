import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.login({required String email, required String pass}) =
      _Login;
  const factory AuthEvent.checkAuthenticated() = _CheckAuthenticated;
  const factory AuthEvent.refreshToken({required String refreshToken}) =
      _RefreshToken;
  const factory AuthEvent.logout() = _Logout;
  const factory AuthEvent.getCurrentUser() = _GetCurrentUser;
}
