abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'AppException(message: $message, statusCode: $statusCode)';
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
  const UnauthorizedException() : super('Unauthorized', 401);
}

class InvalidCredentialsException extends AppException {
  const InvalidCredentialsException() : super('Invalid email or password', 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException() : super('Access denied', 403);
}

/// ===== CACHE / LOCAL =====

class CacheException extends AppException {
  const CacheException([super.message = 'Cache error']);
}

/// ===== DATA =====

class NotFoundException extends AppException {
  const NotFoundException() : super('Resource not found', 404);
}

class ParseException extends AppException {
  const ParseException() : super('Data parsing error');
}

/// ===== FALLBACK =====

class UnexpectedException extends AppException {
  const UnexpectedException(super.message);
}
