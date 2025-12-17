import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// ===== SERVER =====

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error', super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super(message: 'No internet connection');
}

class TimeoutFailure extends Failure {
  const TimeoutFailure() : super(message: 'Connection timeout');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure()
    : super(message: 'Resource not found', statusCode: 404);
}

/// ===== AUTH =====

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super(message: 'Unauthorized', statusCode: 401);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure()
    : super(message: '"Email hoặc mật khẩu không đúng"', statusCode: 401);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure() : super(message: 'Access denied', statusCode: 403);
}

/// ===== CACHE =====

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error'});
}

/// ===== FALLBACK =====

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(String message) : super(message: message);
}
