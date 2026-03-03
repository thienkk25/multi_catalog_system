import 'package:freezed_annotation/freezed_annotation.dart';

part 'export_file_event.freezed.dart';

@freezed
abstract class ExportFileEvent with _$ExportFileEvent {
  const factory ExportFileEvent.exportSingleFile({
    required int type,
    String? format,
  }) = _ExportSingleFile;
  const factory ExportFileEvent.exportCatalogFile({String? format}) =
      _ExportCatalogFile;
}
