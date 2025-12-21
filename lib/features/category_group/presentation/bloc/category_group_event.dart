import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_group_event.freezed.dart';

@freezed
class CategoryGroupEvent with _$CategoryGroupEvent {
  const factory CategoryGroupEvent.getAll({String? search}) = _GetAll;
  const factory CategoryGroupEvent.getById({required String id}) = _GetById;

  const factory CategoryGroupEvent.create({required CategoryGroupEntry entry}) =
      _Create;
  const factory CategoryGroupEvent.createMany({
    required List<CategoryGroupEntry> entities,
  }) = _CreateMany;
  const factory CategoryGroupEvent.upsertMany({
    required List<CategoryGroupEntry> entities,
  }) = _UpsertMany;

  const factory CategoryGroupEvent.update({required CategoryGroupEntry entry}) =
      _Update;

  const factory CategoryGroupEvent.delete({required String id}) = _Delete;
}
