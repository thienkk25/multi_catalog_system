import 'package:equatable/equatable.dart';

class DomainEntry extends Equatable {
  final String? id;
  final String? code;
  final String? name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DomainEntry({
    this.id,
    this.code,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    description,
    createdAt,
    updatedAt,
  ];
}
