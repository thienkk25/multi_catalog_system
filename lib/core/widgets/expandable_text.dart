import 'package:flutter/material.dart';

/// A text widget that automatically truncates to [maxLines] and shows
/// a "Xem thêm" / "Thu gọn" toggle when the content overflows.
class ExpandableText extends StatefulWidget {
  final String text;

  /// Maximum lines to show when collapsed. Defaults to 3.
  final int maxLines;

  /// Text style for the content.
  final TextStyle? style;

  /// Text style for the expand/collapse toggle.
  final TextStyle? toggleStyle;

  /// Label shown when collapsed.
  final String expandLabel;

  /// Label shown when expanded.
  final String collapseLabel;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.style,
    this.toggleStyle,
    this.expandLabel = 'Xem thêm',
    this.collapseLabel = 'Thu gọn',
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = widget.style ?? const TextStyle(fontSize: 13);
    final effectiveToggleStyle = widget.toggleStyle ??
        const TextStyle(
          color: Colors.blue,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(text: widget.text, style: effectiveStyle);
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflow = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: effectiveStyle,
              maxLines: _expanded ? null : widget.maxLines,
              overflow: _expanded ? null : TextOverflow.ellipsis,
            ),
            if (isOverflow)
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _expanded ? widget.collapseLabel : widget.expandLabel,
                    style: effectiveToggleStyle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
