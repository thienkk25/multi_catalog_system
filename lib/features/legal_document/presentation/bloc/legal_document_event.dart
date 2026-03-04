import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';

part 'legal_document_event.freezed.dart';

@freezed
class LegalDocumentEvent with _$LegalDocumentEvent {
  const factory LegalDocumentEvent.getAll({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  }) = _GetAll;
  const factory LegalDocumentEvent.getAllHasFile({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
  }) = _GetAllHasFile;
  const factory LegalDocumentEvent.loadMore() = _LoadMore;
  const factory LegalDocumentEvent.loadMoreHasFile() = _LoadMoreHasFile;
  const factory LegalDocumentEvent.getById({required String id}) = _GetById;

  const factory LegalDocumentEvent.create({
    required LegalDocumentEntry entry,
    PickedDocumentFile? file,
  }) = _Create;

  const factory LegalDocumentEvent.update({
    required LegalDocumentEntry entry,
    PickedDocumentFile? file,
  }) = _Update;

  const factory LegalDocumentEvent.delete({required String id}) = _Delete;

  const factory LegalDocumentEvent.toggleSelect(String id) = _ToggleSelect;
}
