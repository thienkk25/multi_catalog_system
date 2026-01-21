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
  const ServerFailure({super.message = 'Máy chủ lỗi', super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super(message: 'Không có kết nối internet');
}

class TimeoutFailure extends Failure {
  const TimeoutFailure() : super(message: 'Kết nối quá thời gian');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure()
    : super(message: 'Không tìm thấy tài nguyên', statusCode: 404);
}

/// ===== AUTH =====

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({String? message})
    : super(
        message: message ?? 'Chưa đăng nhập hoặc token không hợp lệ',
        statusCode: 401,
      );
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure({String? message})
    : super(
        message: message ?? 'Email hoặc mật khẩu không đúng',
        statusCode: 401,
      );
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({String? message})
    : super(message: message ?? 'Quyền truy cập bị từ chối', statusCode: 403);
}

class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure({String? message})
    : super(message: message ?? 'Phiên đăng nhập đã hết hạn', statusCode: 401);
}

/// ===== CACHE =====

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Lỗi bộ đệm'});
}

/// ===== FALLBACK =====

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(String message) : super(message: message);
}
