import 'package:freezed_annotation/freezed_annotation.dart';

import 'pagination_model.dart';

part 'page_model.freezed.dart';
part 'page_model.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class PageModel<T> with _$PageModel<T> {
  const factory PageModel({
    required List<T> data,
    required PaginationModel pagination,
  }) = _PageModel<T>;

  factory PageModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$PageModelFromJson(json, fromJsonT);
}
