import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/legal_document/data/models/picked_document_file.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entries/legal_document_entry.dart';

part 'legal_document_event.freezed.dart';

@freezed
class LegalDocumentEvent with _$LegalDocumentEvent {
  const factory LegalDocumentEvent.getAll({String? search}) = _GetAll;
  const factory LegalDocumentEvent.getById({required String id}) = _GetById;

  const factory LegalDocumentEvent.create({
    required LegalDocumentEntry entry,
    PickedDocumentFile? file,
  }) = _Create;
  const factory LegalDocumentEvent.createMany({
    required List<LegalDocumentEntry> entities,
  }) = _CreateMany;
  const factory LegalDocumentEvent.upsertMany({
    required List<LegalDocumentEntry> entities,
  }) = _UpsertMany;

  const factory LegalDocumentEvent.update({
    required LegalDocumentEntry entry,
    PickedDocumentFile? file,
  }) = _Update;

  const factory LegalDocumentEvent.delete({required String id}) = _Delete;
}
