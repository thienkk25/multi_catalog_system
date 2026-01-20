import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';

abstract class BaseRemoteDataSource {
  Never handleDioError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    final message = data is Map<String, dynamic> && data['message'] != null
        ? data['message'].toString()
        : 'Có lỗi xảy ra';

    switch (status) {
      case 401:
        throw UnauthorizedException(message: message);

      case 403:
        throw ForbiddenException(message: message);

      case 404:
        throw NotFoundException(message: message);

      default:
        throw ServerException(message, status);
    }
  }
}
