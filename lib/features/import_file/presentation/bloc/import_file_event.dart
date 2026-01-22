import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';

part 'import_file_event.freezed.dart';

@freezed
abstract class ImportFileEvent with _$ImportFileEvent {
  const factory ImportFileEvent.importFile({
    required List<PickedDocumentFile> files,
    required String table,
  }) = _ImportFileEvent;
}
