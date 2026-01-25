String phoneNumberFormatter(String? phoneNumber) {
  if (phoneNumber == null || phoneNumber.isEmpty) return '?';

  final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');

  return digits.replaceAllMapped(
    RegExp(r'(\d{3})(\d{3})(\d{4})'),
    (m) => '${m[1]}xxx${m[3]}',
  );
}
