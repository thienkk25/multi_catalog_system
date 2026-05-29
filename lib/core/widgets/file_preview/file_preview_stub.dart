import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FilePreviewWidget extends StatelessWidget {
  final String url;
  const FilePreviewWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => launchUrl(Uri.parse(url)),
        icon: const Icon(Icons.open_in_browser),
        label: const Text('Mở tệp trong trình duyệt'),
      ),
    );
  }
}
