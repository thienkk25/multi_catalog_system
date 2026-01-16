import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/profile/domain/entities/user_entry.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.error({required String message}) = _Error;
  const factory AuthState.authenticated({required UserEntry entry}) =
      _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
}
