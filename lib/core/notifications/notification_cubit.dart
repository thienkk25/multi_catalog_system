import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(const NotificationState.idle());

  void success(String message) {
    emit(
      NotificationState.show(message: message, type: NotificationType.success),
    );
  }

  void error(String message) {
    emit(
      NotificationState.show(message: message, type: NotificationType.error),
    );
  }

  void warning(String message) {
    emit(
      NotificationState.show(message: message, type: NotificationType.warning),
    );
  }

  void info(String message) {
    emit(NotificationState.show(message: message, type: NotificationType.info));
  }

  void clear() {
    emit(const NotificationState.idle());
  }
}
