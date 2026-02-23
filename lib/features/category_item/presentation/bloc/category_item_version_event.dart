import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';

part 'category_item_version_event.freezed.dart';

@freezed
class CategoryItemVersionEvent with _$CategoryItemVersionEvent {
  const factory CategoryItemVersionEvent.getAll({
    String? itemId,
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  }) = _GetAll;
  const factory CategoryItemVersionEvent.loadMore() = _LoadMore;
  const factory CategoryItemVersionEvent.getById({required String id}) =
      _GetById;

  const factory CategoryItemVersionEvent.createVersion({
    required CategoryItemEntry entry,
  }) = _CreateVersion;

  const factory CategoryItemVersionEvent.updateVersion({
    required CategoryItemEntry entry,
    required String id,
    int? type,
  }) = _UpdateVersion;
  const factory CategoryItemVersionEvent.deleteVersion({required String id}) =
      DeleteVersion;

  const factory CategoryItemVersionEvent.approveVersion({required String id}) =
      _ApproveVersion;

  const factory CategoryItemVersionEvent.rejectVersion({
    required String id,
    required String rejectReason,
  }) = _RejectVersion;

  const factory CategoryItemVersionEvent.delete({required String id}) = Delete;

  const factory CategoryItemVersionEvent.rollbackVersion({required String id}) =
      _RollbackVersion;
}
