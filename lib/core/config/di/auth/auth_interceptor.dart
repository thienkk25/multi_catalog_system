import 'dart:async';

import 'package:dio/dio.dart';
import 'package:multi_catalog_system/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:multi_catalog_system/features/auth/domain/repositories/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthLocalDataSource authLocal;
  final AuthRepository authRepository;

  Completer<void>? _refreshCompleter;

  AuthInterceptor({
    required this.dio,
    required this.authLocal,
    required this.authRepository,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await authLocal.getCachedAuthToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final is401 = err.response?.statusCode == 401;
    final isRefresh = err.requestOptions.path.contains('/auth/refresh');

    if (is401 && !isRefresh) {
      try {
        await _refreshToken();

        final newToken = await authLocal.getCachedAuthToken();
        final requestOptions = err.requestOptions;

        requestOptions.headers['Authorization'] = 'Bearer $newToken';

        final response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      } catch (_) {
        await authRepository.logout();
        return handler.next(err);
      }
    }

    handler.next(err);
  }

  Future<void> _refreshToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer();

    try {
      final refreshToken = await authLocal.getCachedRefreshToken();

      if (refreshToken == null) {
        throw Exception('No refresh token');
      }

      final result = await authRepository.refreshToken(
        refreshToken: refreshToken,
      );

      result.fold((failure) => throw Exception(failure), (_) => null);

      _refreshCompleter!.complete();
    } catch (e) {
      _refreshCompleter!.completeError(e);
      rethrow;
    } finally {
      _refreshCompleter = null;
    }
  }
}
