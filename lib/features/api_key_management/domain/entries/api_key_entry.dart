class ApiKeyEntry {
  final String? id;
  final String key;
  final String systemName;
  final List<String>? allowedDomains;
  final String status;
  final String? createdBy;
  final DateTime createdAt;

  ApiKeyEntry({
    required this.id,
    required this.key,
    required this.systemName,
    required this.allowedDomains,
    required this.status,
    required this.createdBy,
    required this.createdAt,
  });
}
