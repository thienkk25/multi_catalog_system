import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';

abstract class ImportFileRemoteDataSource {
  Future<Map<String, dynamic>> importSingleFile({required FormData data});

  Future<Map<String, dynamic>> importCatalogFile({required FormData data});
}

class ImportFileRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ImportFileRemoteDataSource {
  final Dio dio;

  ImportFileRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> importSingleFile({
    required FormData data,
  }) async {
    try {
      final response = await dio.post(
        '/import/single',
        data: data,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      return response.data;
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> importCatalogFile({
    required FormData data,
  }) async {
    try {
      final response = await dio.post(
        '/import/catalog',
        data: data,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      return response.data;
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
