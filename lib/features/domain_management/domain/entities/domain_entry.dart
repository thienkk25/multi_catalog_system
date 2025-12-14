class DomainEntry {
  final String id;
  final String code;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  DomainEntry({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });
}
