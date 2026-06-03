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
    try {
      final uri = Uri.parse(originalUrl);
      final path = uri.path.toLowerCase();
      if (path.endsWith('.docx') ||
          path.endsWith('.doc') ||
          path.endsWith('.xlsx') ||
          path.endsWith('.xls') ||
          path.endsWith('.pptx') ||
          path.endsWith('.ppt')) {
        return 'https://view.officeapps.live.com/op/embed.aspx?src=${Uri.encodeComponent(originalUrl)}';
      }
    } catch (_) {
      final lowerUrl = originalUrl.toLowerCase();
      if (lowerUrl.contains('.docx') ||
          lowerUrl.contains('.doc') ||
          lowerUrl.contains('.xlsx') ||
          lowerUrl.contains('.xls') ||
          lowerUrl.contains('.pptx') ||
          lowerUrl.contains('.ppt')) {
        return 'https://view.officeapps.live.com/op/embed.aspx?src=${Uri.encodeComponent(originalUrl)}';
      }
    }
    return originalUrl;
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
