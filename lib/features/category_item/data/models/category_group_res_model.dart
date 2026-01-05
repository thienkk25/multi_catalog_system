import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_group_res_entry.dart';

import 'domain_res_model.dart';

part 'category_group_res_model.freezed.dart';
part 'category_group_res_model.g.dart';

@freezed
abstract class CategoryGroupResModel with _$CategoryGroupResModel {
  const factory CategoryGroupResModel({
    required String id,
    required String code,
    required String name,
    required DomainResModel domain,
  }) = _CategoryGroupResModel;

  factory CategoryGroupResModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryGroupResModelFromJson(json);

  factory CategoryGroupResModel.fromEntity(CategoryGroupResEntry entry) {
    return CategoryGroupResModel(
      id: entry.id,
      code: entry.code,
      name: entry.name,
      domain: DomainResModel.fromEntity(entry.domain),
    );
  }
}

extension CategoryGroupResModelMapper on CategoryGroupResModel {
  CategoryGroupResEntry toEntity() {
    return CategoryGroupResEntry(
      id: id,
      code: code,
      name: name,
      domain: domain.toEntity(),
    );
  }
}
