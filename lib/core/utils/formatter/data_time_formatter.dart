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
