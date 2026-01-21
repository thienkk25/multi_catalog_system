import 'exceptions.dart';
import 'failures.dart';

Failure mapExceptionToFailure(AppException e) {
  if (e is InvalidCredentialsException) {
    return InvalidCredentialsFailure(message: e.message);
  }

  if (e is RefreshTokenExpiredException) {
    return const SessionExpiredFailure();
  }

  if (e is UnauthorizedException) {
    return UnauthorizedFailure(message: e.message);
  }

  if (e is ForbiddenException) {
    return ForbiddenFailure(message: e.message);
  }

  if (e is NotFoundException) {
    return NotFoundFailure();
  }

  if (e is CacheException) {
    return CacheFailure(message: e.message);
  }

  if (e is NetworkException) {
    return const NetworkFailure();
  }

  if (e is TimeoutException) {
    return const TimeoutFailure();
  }

  if (e is ServerException) {
    return ServerFailure(message: e.message, statusCode: e.statusCode);
  }

  return UnexpectedFailure('Đã xảy ra lỗi không mong muốn');
}
