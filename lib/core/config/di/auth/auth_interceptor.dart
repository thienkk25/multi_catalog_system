import 'dart:async';
import 'package:dio/dio.dart';
import 'package:multi_catalog_system/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:multi_catalog_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_event.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthLocalDataSource authLocal;
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  Completer<bool>? _refreshCompleter;

  AuthInterceptor({
    required this.dio,
    required this.authLocal,
    required this.authRepository,
    required this.authBloc,
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
  bool _isRefreshing = false;
  Future<bool>? _refreshFuture;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final is401 = err.response?.statusCode == 401;
    final isRefresh = err.requestOptions.extra['isRefresh'] == true;
    final isRetry = err.requestOptions.extra['retry'] == true;

    if (is401 && !isRefresh && !isRetry) {
      if (_isRefreshing && _refreshFuture != null) {
        await _refreshFuture;
      } else {
        _isRefreshing = true;
        _refreshFuture = _refreshToken();

        bool? refreshed;

        try {
          refreshed = await _refreshFuture;
        } finally {
          _isRefreshing = false;
        }

        if (refreshed != true) {
          authBloc.add(AuthEvent.logout());
          return handler.reject(err);
        }
      }

      final newToken = await authLocal.getCachedAuthToken();

      if (newToken == null || newToken.isEmpty) {
        authBloc.add(AuthEvent.logout());
        return handler.reject(err);
      }

      try {
        final requestOptions = err.requestOptions.copyWith(
          headers: {
            ...err.requestOptions.headers,
            'Authorization': 'Bearer $newToken',
          },
          extra: {...err.requestOptions.extra, 'retry': true},
        );

        final response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      } catch (_) {
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
