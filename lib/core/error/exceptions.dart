import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'AppException(message: $message, statusCode: $statusCode)';

  @override
  List<Object?> get props => [message, statusCode];
}

/// ===== SERVER / NETWORK =====

class ServerException extends AppException {
  const ServerException(super.message, [super.statusCode]);
}

class NetworkException extends AppException {
  const NetworkException() : super('No internet connection');
}

class TimeoutException extends AppException {
  const TimeoutException() : super('Connection timeout');
}

/// ===== AUTH =====

class UnauthorizedException extends AppException {
  const UnauthorizedException({String? message})
    : super(message ?? 'Unauthorized', 401);
}

class InvalidCredentialsException extends AppException {
  const InvalidCredentialsException({String? message})
    : super(message ?? 'Invalid email or password', 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException({String? message})
    : super(message ?? 'Access denied', 403);
}

class RefreshTokenExpiredException extends AppException {
  const RefreshTokenExpiredException({String? message})
    : super(message ?? 'Refresh token expired', 401);
}

/// ===== CACHE / LOCAL =====

class CacheException extends AppException {
  const CacheException([super.message = 'Cache error']);
}

/// ===== DATA =====

class NotFoundException extends AppException {
  const NotFoundException({String? message})
    : super(message ?? 'Resource not found', 404);
}

class ParseException extends AppException {
  const ParseException() : super('Data parsing error');
}

/// ===== FALLBACK =====

class UnexpectedException extends AppException {
  const UnexpectedException(super.message);
}
