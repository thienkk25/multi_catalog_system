import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';

abstract class BaseRemoteDataSource {
  Never handleDioError(DioException e) {
    final status = e.response?.statusCode;
    if (status == 401) throw const UnauthorizedException();
    if (status == 403) throw const ForbiddenException();
    if (status == 404) throw const NotFoundException();
    throw ServerException(e.response?.data['message'] ?? 'Máy chủ lỗi', status);
  }
}
