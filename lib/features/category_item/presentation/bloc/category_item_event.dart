import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';

part 'category_item_event.freezed.dart';

@freezed
class CategoryItemEvent with _$CategoryItemEvent {
  const factory CategoryItemEvent.getAll({String? search}) = _GetAll;
  const factory CategoryItemEvent.getById({required String id}) = _GetById;

  const factory CategoryItemEvent.create({required CategoryItemEntry entry}) =
      _Create;
  const factory CategoryItemEvent.update({required CategoryItemEntry entry}) =
      _Update;

  const factory CategoryItemEvent.delete({required String id}) = _Delete;
}
