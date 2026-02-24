import 'package:flutter/material.dart';

class OverlayDropdownLoadButton<T> extends StatefulWidget {
  final Widget? label;
  final List<T> entries;
  final T? selected;
  final String Function(T item) itemLabel;
  final VoidCallback onLoadMore;
  final bool hasMore;
  final bool isLoadingMore;
  final ValueChanged<T>? onSelected;
  final bool isMulti;
  final List<T>? selectedValues;
  final ValueChanged<List<T>>? onMultiSelected;
  final ValueChanged<bool>? onToggle;
  final double? maxHeightOverlay;
  final double? maxWidthOverlay;

  const OverlayDropdownLoadButton({
    super.key,
    this.label,
    required this.entries,
    this.selected,
    required this.itemLabel,
    required this.onLoadMore,
    required this.hasMore,
    required this.isLoadingMore,
    this.onSelected,
    required this.isMulti,
    this.selectedValues,
    this.onMultiSelected,
    this.onToggle,
    this.maxHeightOverlay,
    this.maxWidthOverlay,
  });

  @override
  State<OverlayDropdownLoadButton<T>> createState() =>
      _OverlayDropdownLoadButtonState<T>();
}

class _OverlayDropdownLoadButtonState<T>
    extends State<OverlayDropdownLoadButton<T>>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  final ScrollController _scrollController = ScrollController();

  OverlayEntry? _overlayEntry;
  T? _selected;
  List<T> _selectedList = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool get _isOpen => _overlayEntry != null;

  @override
  void initState() {
    super.initState();
    if (widget.isMulti) {
      _selectedList = List<T>.from(widget.selectedValues ?? []);
    } else {
      _selected = widget.selected;
    }

    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1,
    ).animate(_fadeAnimation);
  }

  @override
  void didUpdateWidget(covariant OverlayDropdownLoadButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isMulti) {
      if (widget.selectedValues != oldWidget.selectedValues) {
        _selectedList = List<T>.from(widget.selectedValues ?? []);
      }
    } else {
      if (widget.selected != oldWidget.selected) {
        _selected = widget.selected;
      }
    }

    _onRebuildOverlay();
  }

  void _onRebuildOverlay() {
    if (_overlayEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    }
  }

  void _onScroll() {
    if (_overlayEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    }
    if (!_scrollController.hasClients) return;
    if (!widget.hasMore) return;
    if (widget.isLoadingMore) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 100) {
      widget.onLoadMore();
    }
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _removeOverlay,
          child: Stack(
            children: [
              Positioned.fill(child: Container()),
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, 50),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: widget.maxWidthOverlay ?? 400,
                        maxHeight: widget.maxHeightOverlay ?? 250,
                      ),
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.zero,
                          itemCount:
                              widget.entries.length +
                              (widget.isLoadingMore || widget.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == widget.entries.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            final item = widget.entries[index];
                            final isSelected = widget.isMulti
                                ? _selectedList.contains(item)
                                : item == _selected;

                            return InkWell(
                              onTap: () {
                                if (widget.isMulti) {
                                  setState(() {
                                    if (_selectedList.contains(item)) {
                                      _selectedList.remove(item);
                                    } else {
                                      _selectedList.add(item);
                                    }
                                  });

                                  widget.onMultiSelected?.call(_selectedList);
                                  _onRebuildOverlay();
                                } else {
                                  setState(() => _selected = item);
                                  widget.onSelected?.call(item);
                                  _removeOverlay();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                color: isSelected
                                    ? Colors.blue.withValues(alpha: .1)
                                    : null,
                                child: Row(
                                  children: [
                                    if (widget.isMulti)
                                      Checkbox(
                                        value: isSelected,
                                        onChanged: (_) {
                                          setState(() {
                                            if (_selectedList.contains(item)) {
                                              _selectedList.remove(item);
                                            } else {
                                              _selectedList.add(item);
                                            }
                                            _onRebuildOverlay();
                                          });

                                          widget.onMultiSelected?.call(
                                            _selectedList,
                                          );
                                        },
                                      ),
                                    Expanded(
                                      child: Text(
                                        widget.itemLabel(item),
                                        style: TextStyle(
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleOverlay() {
    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
      _animationController.forward(from: 0);
      widget.onToggle?.call(_isOpen);
    }
  }

  void _removeOverlay() {
    if (!mounted) return;

    if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    }

    _overlayEntry?.remove();
    _overlayEntry = null;
    widget.onToggle?.call(_isOpen);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedValue = widget.isMulti
        ? (_selectedList.isEmpty ? "---" : "${_selectedList.length} đã chọn")
        : (_selected != null ? widget.itemLabel(_selected as T) : "---");

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        ?widget.label,
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleOverlay,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedValue),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
