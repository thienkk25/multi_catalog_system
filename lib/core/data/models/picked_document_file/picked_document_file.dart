import 'dart:io';
import 'dart:typed_data';

class PickedDocumentFile {
  final String? name;
  final String? path;
  final int? size;
  final Uint8List? bytes; // web
  final File? file; // mobile

  const PickedDocumentFile({
    this.name,
    this.size,
    this.bytes,
    this.file,
    this.path,
  });
}
