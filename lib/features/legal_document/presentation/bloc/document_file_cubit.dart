import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';

import 'document_file_state.dart';

class DocumentFileCubit extends Cubit<DocumentFileState> {
  DocumentFileCubit() : super(const DocumentFileState());

  void setRemoteFile(String? fileName) {
    emit(state.copyWith(remoteFileName: fileName));
  }

  Future<void> pickFile() async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        clearFile: true,
        clearRemote: true,
      ),
    );

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: kIsWeb,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final picked = result.files.single;

      final file = PickedDocumentFile(
        name: picked.name,
        size: picked.size,
        bytes: kIsWeb ? picked.bytes : null,
        file: kIsWeb ? null : File(picked.path!),
      );

      emit(state.copyWith(isLoading: false, file: file));
    } catch (_) {
      emit(state.copyWith(isLoading: false, error: 'Không thể chọn tệp'));
    }
  }

  void clear() {
    emit(const DocumentFileState());
  }
}
