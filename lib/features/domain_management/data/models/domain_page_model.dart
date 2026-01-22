import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/data/models/pagination/pagination_model.dart';

import 'domain_model.dart';

part 'domain_page_model.freezed.dart';
part 'domain_page_model.g.dart';

@freezed
abstract class DomainPageModel with _$DomainPageModel {
  const factory DomainPageModel({
    required List<DomainModel> data,
    required PaginationModel pagination,
  }) = _DomainPageModel;

  factory DomainPageModel.fromJson(Map<String, dynamic> json) =>
      _$DomainPageModelFromJson(json);
}
