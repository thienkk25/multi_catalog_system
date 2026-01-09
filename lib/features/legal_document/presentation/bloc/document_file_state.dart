import 'package:multi_catalog_system/features/legal_document/data/models/picked_document_file.dart';

class DocumentFileState {
  final bool isLoading;
  final PickedDocumentFile? file; // file local
  final String? remoteFileName; // file từ server
  final String? error;

  const DocumentFileState({
    this.isLoading = false,
    this.file,
    this.remoteFileName,
    this.error,
  });

  bool get hasFile => file != null || remoteFileName != null;

  DocumentFileState copyWith({
    bool? isLoading,
    PickedDocumentFile? file,
    String? remoteFileName,
    String? error,
    bool clearFile = false,
    bool clearRemote = false,
  }) {
    return DocumentFileState(
      isLoading: isLoading ?? this.isLoading,
      file: clearFile ? null : file ?? this.file,
      remoteFileName: clearRemote
          ? null
          : remoteFileName ?? this.remoteFileName,
      error: error,
    );
  }
}
