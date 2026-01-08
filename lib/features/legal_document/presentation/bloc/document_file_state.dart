import 'package:multi_catalog_system/features/legal_document/data/models/picked_document_file.dart';

class DocumentFileState {
  final bool isLoading;
  final PickedDocumentFile? file;
  final String? error;

  const DocumentFileState({this.isLoading = false, this.file, this.error});

  DocumentFileState copyWith({
    bool? isLoading,
    PickedDocumentFile? file,
    String? error,
  }) {
    return DocumentFileState(
      isLoading: isLoading ?? this.isLoading,
      file: file,
      error: error,
    );
  }
}
