import 'package:flutter/material.dart';

class CodeBlockWidget extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  final double borderRadius;
  final Color backgroundColor;

  const CodeBlockWidget({
    super.key,
    required this.text,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = 12,
    this.backgroundColor = const Color(0xFFF3F4F6),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: SelectableText(
        text,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
      ),
    );
  }
}
