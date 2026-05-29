import 'package:flutter/material.dart';
import 'file_preview/file_preview.dart';

class FilePreviewDialog extends StatelessWidget {
  final String url;
  final String fileName;

  const FilePreviewDialog({
    super.key,
    required this.url,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    fileName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FilePreviewWidget(url: url),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showFilePreviewDialog(BuildContext context, String url, String fileName) {
  showDialog(
    context: context,
    builder: (context) => FilePreviewDialog(url: url, fileName: fileName),
  );
}
