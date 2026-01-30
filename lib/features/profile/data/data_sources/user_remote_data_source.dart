import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/data/models/auth/user_profile_model.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';

abstract class UserRemoteDataSource {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> changePassword({required Map<String, dynamic> data});
  Future<UserProfileModel> updateProfile({required Map<String, dynamic> data});
}

class UserRemoteDataSourceImpl extends BaseRemoteDataSource
    implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserProfileModel> changePassword({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.patch('/user/change-password', data: data);
      return UserProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> getProfile() async {
    try {
      final response = await dio.get('/user/profile');
      return UserProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> updateProfile({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.patch('/user/update-profile', data: data);

      return UserProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
