import 'dart:io';
import 'dart:typed_data';

class PickedDocumentFile {
  final String name;
  final int size;
  final Uint8List? bytes; // web
  final File? file; // mobile

  const PickedDocumentFile({
    required this.name,
    required this.size,
    this.bytes,
    this.file,
  });
}
