class UserEntry {
  String id;
  String email;
  String? fullName;
  String? phone;
  String status;
  DateTime createdAt;
  DateTime? updatedAt;
  UserEntry({
    required this.id,
    required this.email,
    this.fullName,
    this.phone,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });
}
