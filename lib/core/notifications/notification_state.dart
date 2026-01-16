import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_state.freezed.dart';

enum NotificationType { success, error, warning, info }

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState.idle() = _Idle;

  const factory NotificationState.show({
    required String message,
    @Default(NotificationType.info) NotificationType type,
  }) = _Show;
}
