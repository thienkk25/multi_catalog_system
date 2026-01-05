import 'domain_res_entry.dart';

class CategoryGroupResEntry {
  final String id;
  final String code;
  final String name;
  final DomainResEntry domain;

  CategoryGroupResEntry({
    required this.id,
    required this.code,
    required this.name,
    required this.domain,
  });
}
