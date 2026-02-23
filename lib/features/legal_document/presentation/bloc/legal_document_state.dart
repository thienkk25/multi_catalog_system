import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';

part 'legal_document_state.freezed.dart';

@freezed
abstract class LegalDocumentState with _$LegalDocumentState {
  const factory LegalDocumentState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,

    String? search,
    @Default(1) int page,
    @Default(20) int limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
    @Default([]) List<LegalDocumentEntry> entries,
    @Default({}) Set<String> selectedIds,
    LegalDocumentEntry? entry,
    String? error,
    String? successMessage,
  }) = _LegalDocumentState;
}
