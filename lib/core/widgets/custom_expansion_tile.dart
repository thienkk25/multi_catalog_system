import 'package:flutter/material.dart';

/// A drop-in replacement for [ExpansionTile] that avoids the Flutter Web
/// PageStorage bug where expansion state is stored as `int` instead of `bool`,
/// causing a `TypeError: type 'int' is not a subtype of type 'bool?'`.
///
/// Uses [AnimatedCrossFade] for a smooth expand/collapse animation.
class CustomExpansionTile extends StatefulWidget {
  /// The primary content of the tile header.
  final Widget title;

  /// The widgets displayed when the tile is expanded.
  final List<Widget> children;

  /// Whether the tile is initially expanded. Defaults to `false`.
  final bool initiallyExpanded;

  /// Background color when collapsed.
  final Color? collapsedBackgroundColor;

  /// Background color when expanded.
  final Color? backgroundColor;

  /// Text/icon color when collapsed.
  final Color? collapsedTextColor;

  /// Text/icon color when expanded.
  final Color? textColor;

  /// Icon color when collapsed.
  final Color? collapsedIconColor;

  /// Icon color when expanded.
  final Color? iconColor;

  /// Duration of the expand/collapse animation.
  final Duration duration;

  /// Called when expansion state changes.
  final ValueChanged<bool>? onExpansionChanged;

  const CustomExpansionTile({
    super.key,
    required this.title,
    this.children = const [],
    this.initiallyExpanded = false,
    this.collapsedBackgroundColor,
    this.backgroundColor,
    this.collapsedTextColor,
    this.textColor,
    this.collapsedIconColor,
    this.iconColor,
    this.duration = const Duration(milliseconds: 200),
    this.onExpansionChanged,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isExpanded
        ? (widget.backgroundColor ?? Colors.transparent)
        : (widget.collapsedBackgroundColor ?? Colors.transparent);

    final contentColor = _isExpanded
        ? (widget.textColor ?? Colors.black87)
        : (widget.collapsedTextColor ?? Colors.black87);

    final arrowColor = _isExpanded
        ? (widget.iconColor ?? contentColor)
        : (widget.collapsedIconColor ?? contentColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _toggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: contentColor,
                      fontWeight: FontWeight.w500,
                    ),
                    child: widget.title,
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: arrowColor,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: widget.children,
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: widget.duration,
        ),
      ],
    );
  }
}
