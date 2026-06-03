import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  String _getWebSafeUrl(String url) {
    var processedUrl = url.trim();
    if (processedUrl.contains('drive.google.com')) {
      final regExp = RegExp(r'\/d\/([a-zA-Z0-9-_]+)');
      final match = regExp.firstMatch(processedUrl);
      if (match != null && match.groupCount >= 1) {
        final fileId = match.group(1);
        processedUrl = 'https://lh3.googleusercontent.com/d/$fileId';
      } else {
        final idUri = Uri.tryParse(processedUrl);
        final fileId = idUri?.queryParameters['id'];
        if (fileId != null) {
          processedUrl = 'https://lh3.googleusercontent.com/d/$fileId';
        }
      }
    }

    if (kIsWeb) {
      try {
        final uri = Uri.parse(processedUrl);
        if (!uri.host.contains('localhost') &&
            !uri.host.contains('127.0.0.1')) {
          return 'https://wsrv.nl/?url=${Uri.encodeComponent(processedUrl)}';
        }
      } catch (_) {}
    }
    return processedUrl;
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildError();
    }

    Widget image;
    if (imageUrl!.startsWith('data:image')) {
      // Handle Base64 Data URI
      try {
        final base64String = imageUrl!.split(',').last;
        final bytes = base64Decode(base64String);
        image = Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) => _buildError(),
        );
      } catch (e) {
        image = _buildError();
      }
    } else {
      // Handle normal URL
      image = CachedNetworkImage(
        imageUrl: _getWebSafeUrl(imageUrl!),
        width: width,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.high,
        placeholder: (context, url) =>
            placeholder ??
            const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
        errorWidget: (context, url, error) => _buildError(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }

  Widget _buildError() {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          color: Colors.grey.shade100,
          child: Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: (width != null && width! < 50) ? 20 : 48,
              color: Colors.grey.shade400,
            ),
          ),
        );
  }
}
