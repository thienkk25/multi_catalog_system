import 'package:intl/intl.dart';

String dateTimeFormatFull(DateTime? dateTime) {
  if (dateTime == null) return 'N/A';
  return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
}

String dateTimeFormat(DateTime? dateTime) {
  if (dateTime == null) return 'N/A';
  return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
}

String dateFormat(DateTime? dateTime) {
  if (dateTime == null) return 'N/A';
  return DateFormat('dd/MM/yyyy').format(dateTime);
}

String timeFormat(DateTime? dateTime) {
  if (dateTime == null) return 'N/A';
  return DateFormat('HH:mm').format(dateTime);
}

String formatValue(dynamic value) {
  if (value == null) return 'null';

  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(parsed.toLocal());
    }
  }

  return value.toString();
}
