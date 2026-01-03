import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/system_history_management/data/models/system_history_model.dart';

abstract class SystemHistoryRemoteDataSource {
  Future<List<SystemHistoryModel>> getAll({String? search});
  Future<SystemHistoryModel> getById(String id);
}

class SystemHistoryRemoteDataSourceImpl extends BaseRemoteDataSource
    implements SystemHistoryRemoteDataSource {
  final Dio dio;

  SystemHistoryRemoteDataSourceImpl({required this.dio});
  @override
  Future<List<SystemHistoryModel>> getAll({String? search}) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null) queryParams['search'] = search;

      final response = await dio.get(
        '/activity-log',
        queryParameters: queryParams,
      );

      final List<dynamic> jsonList = response.data['data']['data'];
      return jsonList.map((json) => SystemHistoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<SystemHistoryModel> getById(String id) async {
    try {
      final response = await dio.get('/activity-log/$id');
      return SystemHistoryModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
