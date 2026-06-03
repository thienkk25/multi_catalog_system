import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;

class FilePreviewWidget extends StatefulWidget {
  final String url;
  const FilePreviewWidget({super.key, required this.url});

  @override
  State<FilePreviewWidget> createState() => _FilePreviewWidgetState();
}

class _FilePreviewWidgetState extends State<FilePreviewWidget> {
  late final String viewId;

  String _getPreviewUrl(String originalUrl) {
    var processedUrl = originalUrl.trim();
    
    // Tự động phát hiện link Google Drive và chuyển sang dạng /preview để cho phép nhúng IFrame
    if (processedUrl.contains('drive.google.com')) {
      final regExp = RegExp(r'\/d\/([a-zA-Z0-9-_]+)');
      final match = regExp.firstMatch(processedUrl);
      if (match != null && match.groupCount >= 1) {
        final fileId = match.group(1);
        return 'https://drive.google.com/file/d/$fileId/preview';
      }
      final idUri = Uri.tryParse(processedUrl);
      final fileId = idUri?.queryParameters['id'];
      if (fileId != null) {
        return 'https://drive.google.com/file/d/$fileId/preview';
      }
    }

    try {
      final uri = Uri.parse(processedUrl);
      final path = uri.path.toLowerCase();
      if (path.endsWith('.docx') ||
          path.endsWith('.doc') ||
          path.endsWith('.xlsx') ||
          path.endsWith('.xls') ||
          path.endsWith('.pptx') ||
          path.endsWith('.ppt')) {
        return 'https://view.officeapps.live.com/op/embed.aspx?src=${Uri.encodeComponent(processedUrl)}';
      }
    } catch (_) {
      final lowerUrl = processedUrl.toLowerCase();
      if (lowerUrl.contains('.docx') ||
          lowerUrl.contains('.doc') ||
          lowerUrl.contains('.xlsx') ||
          lowerUrl.contains('.xls') ||
          lowerUrl.contains('.pptx') ||
          lowerUrl.contains('.ppt')) {
        return 'https://view.officeapps.live.com/op/embed.aspx?src=${Uri.encodeComponent(processedUrl)}';
      }
    }
    return processedUrl;
  }

  @override
  void initState() {
    super.initState();
    viewId = 'iframe-${widget.url.hashCode}-${DateTime.now().millisecondsSinceEpoch}';
    ui_web.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) {
        final iframe = web.HTMLIFrameElement()
          ..src = _getPreviewUrl(widget.url)
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: viewId);
  }
}
