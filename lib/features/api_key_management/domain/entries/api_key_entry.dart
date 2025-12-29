class ApiKeyEntry {
  String? id;
  final String key;
  final String systemName;
  List<String>? allowedDomains;
  final String status;
  final String createBy;
  final DateTime createdAt;

  ApiKeyEntry({
    required this.key,
    required this.systemName,
    this.allowedDomains,
    required this.status,
    required this.createBy,
    required this.createdAt,
  });
}
