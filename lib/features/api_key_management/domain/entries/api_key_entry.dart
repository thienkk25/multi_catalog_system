class ApiKeyEntry {
  final String? id;
  final String? key;
  final String? systemName;
  final List<String>? allowedDomains;
  final String? status;
  final String? createdBy;
  final DateTime? createdAt;

  ApiKeyEntry({
    this.id,
    this.key,
    this.systemName,
    this.allowedDomains,
    this.status,
    this.createdBy,
    this.createdAt,
  });
}
