import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/catalog_lookup/domain/entities/domain_ref_entry.dart';

part 'domain_ref_model.freezed.dart';
part 'domain_ref_model.g.dart';

@freezed
abstract class DomainRefModel with _$DomainRefModel {
  const factory DomainRefModel({
    required String id,
    required String code,
    required String name,
  }) = _DomainRefModel;

  factory DomainRefModel.fromJson(Map<String, dynamic> json) =>
      _$DomainRefModelFromJson(json);

  factory DomainRefModel.fromEntity(DomainRefEntry entry) {
    return DomainRefModel(id: entry.id, code: entry.id, name: entry.name);
  }
}

extension DomainRefModelMapper on DomainRefModel {
  DomainRefEntry toEntity() {
    return DomainRefEntry(id: id, code: code, name: name);
  }
}
