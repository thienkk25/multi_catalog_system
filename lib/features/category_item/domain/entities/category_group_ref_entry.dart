import 'package:equatable/equatable.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';

class CategoryGroupRefEntry extends Equatable {
  final String? id;
  final String? code;
  final String? name;
  final DomainRefEntry? domain;

  const CategoryGroupRefEntry({this.id, this.name, this.code, this.domain});

  @override
  List<Object?> get props => [id, name, code];
}
