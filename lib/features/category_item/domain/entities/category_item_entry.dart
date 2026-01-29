import 'package:equatable/equatable.dart';

class CategoryItemEntry extends Equatable {
  final String? id;
  final String? code;
  final String? name;
  final String? description;
  final String? status;
  final String? groupId;
  final String? groupName;
  final String? domainName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryItemEntry({
    this.id,
    this.code,
    this.name,
    this.description,
    this.status,
    this.groupId,
    this.groupName,
    this.domainName,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    description,
    status,
    groupId,
    groupName,
    domainName,
    createdAt,
    updatedAt,
  ];
}
