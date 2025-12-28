import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entries/legal_document_entry.dart';

part 'legal_document_state.freezed.dart';

@freezed
abstract class LegalDocumentState with _$LegalDocumentState {
  const factory LegalDocumentState({
    @Default(false) bool isLoading,
    @Default([]) List<LegalDocumentEntry> entities,
    String? error,
    String? successMessage,
  }) = _LegalDocumentState;
}
