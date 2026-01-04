class ApiKeyEntry {
  final String? id;
  final String key;
  final String systemName;
  final List<String>? allowedDomains;
  final String status;
  final String? createdBy;
  final DateTime createdAt;

  ApiKeyEntry({
    this.id,
    required this.key,
    required this.systemName,
    this.allowedDomains,
    required this.status,
    this.createdBy,
    required this.createdAt,
  });
}
