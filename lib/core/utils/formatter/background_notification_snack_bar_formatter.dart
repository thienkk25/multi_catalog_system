import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/notifications/notification_state.dart';

Color bgColorNotificationSnackBar(NotificationType type) {
  switch (type) {
    case NotificationType.success:
      return Colors.green;
    case NotificationType.error:
      return Colors.red;
    case NotificationType.info:
      return Colors.blue;
    case NotificationType.warning:
      return Colors.orange;
  }
}
