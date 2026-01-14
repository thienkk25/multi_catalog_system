import 'package:multi_catalog_system/core/error/failures.dart';

String mapFailure(Failure failure) {
  if (failure is ServerFailure) return failure.message;
  if (failure is CacheFailure) return failure.message;
  if (failure is UnexpectedFailure) return failure.message;
  return 'Unknown error';
}
