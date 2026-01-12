import 'package:freezed_annotation/freezed_annotation.dart';

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
}
