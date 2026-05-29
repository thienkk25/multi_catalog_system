import 'dart:convert';
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
      image = Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.high,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ??
              Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
        },
        errorBuilder: (context, error, stackTrace) => _buildError(),
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
