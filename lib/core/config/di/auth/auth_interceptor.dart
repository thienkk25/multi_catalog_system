import 'dart:async';
import 'package:dio/dio.dart';
import 'package:multi_catalog_system/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:multi_catalog_system/features/auth/domain/repositories/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthLocalDataSource authLocal;
  final AuthRepository authRepository;

  Completer<bool>? _refreshCompleter;

  AuthInterceptor({
    required this.dio,
    required this.authLocal,
    required this.authRepository,
  });

  // ================= REQUEST =================
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

  // ================= ERROR =================
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final is401 = err.response?.statusCode == 401;
    final isRefresh = err.requestOptions.path.contains('/auth/refresh');

    if (is401 && !isRefresh) {
      final refreshed = await _refreshToken();

      if (!refreshed) {
        // Nếu refresh token thất bại → logout
        await authLocal.clearAuthToken();
        authRepository.notifyUnauthenticated();

        // NUỐT 401 – không cho rơi xuống data layer
        return handler.resolve(
          Response(
            requestOptions: err.requestOptions,
            statusCode: 401,
            data: {
              'success': false,
              'error': 'unauthorized',
              'message': 'Phiên đăng nhập đã hết hạn',
            },
          ),
        );
      }

      // Lấy token mới
      final newToken = await authLocal.getCachedAuthToken();
      if (newToken == null || newToken.isEmpty) {
        await authRepository.logout();

        return handler.resolve(
          Response(
            requestOptions: err.requestOptions,
            statusCode: 401,
            data: {
              'success': false,
              'error': 'unauthorized',
              'message': 'Phiên đăng nhập đã hết hạn',
            },
          ),
        );
      }

      try {
        final requestOptions = err.requestOptions;
        requestOptions.headers['Authorization'] = 'Bearer $newToken';

        final response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.reject(err);
      }
    }

    handler.next(err);
  }

  // ================= REFRESH TOKEN =================
  Future<bool> _refreshToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = await authLocal.getCachedRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await authLocal.clearAuthToken();
        _refreshCompleter!.complete(false);
        return false;
      }

      final result = await authRepository.refreshToken(
        refreshToken: refreshToken,
      );

      final success = result.isRight();

      if (!success) {
        await authLocal.clearAuthToken();
      }

      _refreshCompleter!.complete(success);
      return success;
    } catch (_) {
      await authLocal.clearAuthToken();
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }
}
