import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/domain_res_entry.dart';

part 'domain_res_model.freezed.dart';
part 'domain_res_model.g.dart';

@freezed
abstract class DomainResModel with _$DomainResModel {
  const factory DomainResModel({
    required String id,
    required String code,
    required String name,
  }) = _DomainResModel;

  factory DomainResModel.fromJson(Map<String, dynamic> json) =>
      _$DomainResModelFromJson(json);

  factory DomainResModel.fromEntity(DomainResEntry entry) {
    return DomainResModel(id: entry.id, code: entry.code, name: entry.name);
  }
}

extension DomainResModelMapper on DomainResModel {
  DomainResEntry toEntity() {
    return DomainResEntry(id: id, code: code, name: name);
  }
}
