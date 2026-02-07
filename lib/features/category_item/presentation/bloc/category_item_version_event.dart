import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';

part 'category_item_version_event.freezed.dart';

@freezed
class CategoryItemVersionEvent with _$CategoryItemVersionEvent {
  const factory CategoryItemVersionEvent.getAll({
    required String itemId,
    String? search,
  }) = GetAll;

  const factory CategoryItemVersionEvent.getById({required String id}) =
      GetById;

  const factory CategoryItemVersionEvent.createVersion({
    required CategoryItemEntry entry,
  }) = CreateVersion;

  const factory CategoryItemVersionEvent.updateVersion({
    required CategoryItemEntry entry,
  }) = UpdateVersion;
  const factory CategoryItemVersionEvent.deleteVersion({required String id}) =
      DeleteVersion;

  const factory CategoryItemVersionEvent.approveVersion({required String id}) =
      ApproveVersion;

  const factory CategoryItemVersionEvent.rejectVersion({
    required String id,
    required String rejectReason,
  }) = RejectVersion;

  const factory CategoryItemVersionEvent.delete({required String id}) = Delete;
}
