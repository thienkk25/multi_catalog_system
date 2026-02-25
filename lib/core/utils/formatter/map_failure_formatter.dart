import 'package:multi_catalog_system/core/error/failures.dart';

String mapFailure(Failure failure) {
  if (failure is ServerFailure) return failure.message;
  if (failure is CacheFailure) return failure.message;
  if (failure is UnexpectedFailure) return failure.message;
  if (failure is NetworkFailure) return failure.message;
  if (failure is TimeoutFailure) return failure.message;
  if (failure is SessionExpiredFailure) return failure.message;
  if (failure is UnauthorizedFailure) return failure.message;
  if (failure is ForbiddenFailure) return failure.message;
  if (failure is NotFoundFailure) return failure.message;
  if (failure is InvalidCredentialsFailure) return failure.message;

  return 'Unknown error';
}
