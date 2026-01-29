import 'package:equatable/equatable.dart';

class CategoryGroupEntry extends Equatable {
  final String? id;
  final String? domainId;
  final String? code;
  final String? name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const CategoryGroupEntry({
    this.id,
    this.domainId,
    this.code,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    domainId,
    code,
    name,
    description,
    createdAt,
    updatedAt,
  ];
}
