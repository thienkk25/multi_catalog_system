import 'dart:convert';

import 'package:multi_catalog_system/features/auth/data/models/user_model.dart';
import 'package:multi_catalog_system/features/auth/data/models/user_role_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthToken(String token);
  Future<String?> getCachedAuthToken();

  Future<void> cacheRefreshToken(String refreshToken);
  Future<String?> getCachedRefreshToken();

  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();

  Future<void> cacheUserRole(UserRoleModel userRole);
  Future<UserRoleModel?> getCachedUserRole();

  Future<void> clearAuthToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _accessTokenKey = 'CACHED_AUTH_TOKEN';
  static const String _refreshTokenKey = 'CACHED_REFRESH_TOKEN';
  static const String _userKey = 'CACHED_USER';
  static const String _userRoleKey = 'CACHED_USER_ROLE';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheAuthToken(String token) async {
    await sharedPreferences.setString(_accessTokenKey, token);
  }

  @override
  Future<String?> getCachedAuthToken() async {
    return sharedPreferences.getString(_accessTokenKey);
  }

  @override
  Future<void> cacheRefreshToken(String refreshToken) async {
    await sharedPreferences.setString(_refreshTokenKey, refreshToken);
  }

  @override
  Future<String?> getCachedRefreshToken() async {
    return sharedPreferences.getString(_refreshTokenKey);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await sharedPreferences.setString(_userKey, userJson);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userJson = sharedPreferences.getString(_userKey);
    if (userJson == null) return null;

    return UserModel.fromJson(jsonDecode(userJson));
  }

  @override
  Future<void> cacheUserRole(UserRoleModel userRole) {
    final userRoleJson = jsonEncode(userRole.toJson());
    return sharedPreferences.setString(_userRoleKey, userRoleJson);
  }

  @override
  Future<UserRoleModel?> getCachedUserRole() async {
    final userRoleJson = sharedPreferences.getString(_userRoleKey);

    if (userRoleJson == null) return null;

    return UserRoleModel.fromJson(jsonDecode(userRoleJson));
  }

  @override
  Future<void> clearAuthToken() async {
    await Future.wait([
      sharedPreferences.remove(_accessTokenKey),
      sharedPreferences.remove(_refreshTokenKey),
      sharedPreferences.remove(_userKey),
      sharedPreferences.remove(_userRoleKey),
    ]);
  }
}
