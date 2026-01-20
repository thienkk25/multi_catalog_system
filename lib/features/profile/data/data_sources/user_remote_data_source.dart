import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/data/models/auth/user_model.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/profile/data/models/profile_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getMe();
  Future<ProfileModel> getProfile();
  Future<UserModel> changePassword({required Map<String, dynamic> data});
  Future<UserModel> updateProfile({required Map<String, dynamic> data});
}

class UserRemoteDataSourceImpl extends BaseRemoteDataSource
    implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> changePassword({required Map<String, dynamic> data}) async {
    try {
      final response = await dio.patch('/user/change-password', data: data);
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await dio.get('/user/');
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await dio.get('/user/profile');
      return ProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserModel> updateProfile({required Map<String, dynamic> data}) async {
    try {
      final response = await dio.patch('/user/update-profile', data: data);

      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
