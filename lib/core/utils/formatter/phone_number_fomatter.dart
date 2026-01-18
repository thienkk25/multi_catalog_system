String phoneNumberFormatter(String? phoneNumber) {
  if (phoneNumber == null) return '?';

  final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
  if (digits.length != 10) return phoneNumber;

  return digits.replaceAllMapped(
    RegExp(r'(\d{3})(\d{3})(\d{4})'),
    (m) => '${m[1]}xxx${m[3]}',
  );
}
