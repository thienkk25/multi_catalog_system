import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/domain_management/domain/domain.dart';

part 'domain_model.freezed.dart';
part 'domain_model.g.dart';

@freezed
abstract class DomainModel with _$DomainModel {
  const factory DomainModel({
    required String id,
    required String code,
    required String name,
    required String description,
    @JsonKey(name: 'create_at') required DateTime createdAt,
    @JsonKey(name: 'update_at') DateTime? updatedAt,
  }) = _DomainModel;

  factory DomainModel.fromJson(Map<String, dynamic> json) =>
      _$DomainModelFromJson(json);

  factory DomainModel.fromEntity(DomainEntry entry) {
    return DomainModel(
      id: entry.id,
      code: entry.code,
      name: entry.name,
      description: entry.description,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }
}

extension DomainModelMapper on DomainModel {
  DomainEntry toEntity() {
    return DomainEntry(
      id: id,
      code: code,
      name: name,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
