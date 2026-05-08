import 'package:flutter/material.dart';

class ImageUrlInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Widget? label;
  final String? hintText;

  const ImageUrlInputWidget({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
  });

  @override
  State<ImageUrlInputWidget> createState() => _ImageUrlInputWidgetState();
}

class _ImageUrlInputWidgetState extends State<ImageUrlInputWidget> {
  String? _previewUrl;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _previewUrl = widget.controller.text.isNotEmpty ? widget.controller.text : null;
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = widget.controller.text.trim();
    setState(() {
      _hasError = false;
      _previewUrl = text.isNotEmpty ? text : null;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          widget.label!,
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Nhập URL hình ảnh...',
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(Icons.image_outlined),
            suffixIcon: _previewUrl != null
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      widget.controller.clear();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        if (_previewUrl != null) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _hasError ? Colors.red.shade300 : Colors.grey.shade300,
                ),
              ),
              child: _hasError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Không thể tải hình ảnh',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Image.network(
                      _previewUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() => _hasError = true);
                          }
                        });
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Không thể tải hình ảnh',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
