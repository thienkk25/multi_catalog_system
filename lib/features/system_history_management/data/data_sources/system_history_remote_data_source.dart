import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/data/models/page/page_model.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/system_history_management/data/models/system_history_model.dart';

abstract class SystemHistoryRemoteDataSource {
  Future<PageModel<SystemHistoryModel>> getAll({
    String? search,
    int? page,
    int? limit,
    Map<String, dynamic>? filter,
  });
  Future<SystemHistoryModel> getById({required String id});
}

class SystemHistoryRemoteDataSourceImpl extends BaseRemoteDataSource
    implements SystemHistoryRemoteDataSource {
  final Dio dio;

  SystemHistoryRemoteDataSourceImpl({required this.dio});
  @override
  Future<PageModel<SystemHistoryModel>> getAll({
    String? search,
    int? page,
    int? limit,
    Map<String, dynamic>? filter,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null) queryParams['search'] = search;

      if (page != null) queryParams['page'] = page;

      if (limit != null) queryParams['limit'] = limit;

      if (filter != null) queryParams['filter'] = filter;

      final response = await dio.get(
        '/activity-log',
        queryParameters: queryParams,
      );

      final data = response.data['data'];
      return PageModel<SystemHistoryModel>.fromJson(
        data,
        (e) => SystemHistoryModel.fromJson(e as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<SystemHistoryModel> getById({required String id}) async {
    try {
      final response = await dio.get('/activity-log/$id');
      return SystemHistoryModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
