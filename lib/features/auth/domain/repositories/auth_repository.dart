import 'package:multi_catalog_system/features/auth/domain/entities/user_entry.dart';

abstract class AuthRepository {
  Future<void> login({required String email, required String pass});
  Future<bool> checkAuthenticated();
  Future<UserEntry?> getCurrentUser();
  Future<void> refreshToken({required String refreshToken});
  Future<void> logout();
}
