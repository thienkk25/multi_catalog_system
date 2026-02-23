import 'package:flutter/material.dart';

class OverlayDropdownLoadButton<T> extends StatefulWidget {
  final Widget? label;
  final List<T> entries;
  final T? selected;
  final String Function(T item) itemLabel;
  final VoidCallback onLoadMore;
  final bool hasMore;
  final bool isLoadingMore;
  final ValueChanged<T> onSelected;

  const OverlayDropdownLoadButton({
    super.key,
    this.label,
    required this.entries,
    this.selected,
    required this.itemLabel,
    required this.onLoadMore,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onSelected,
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

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
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
    if (widget.selected != oldWidget.selected) {
      _selected = widget.selected;
    }
    if (_overlayEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    }
  }

  void _onScroll() {
    _overlayEntry?.markNeedsBuild();
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
                        maxWidth: 400,
                        maxHeight: 250,
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
                            final isSelected = item == widget.selected;

                            return InkWell(
                              onTap: () {
                                setState(() => _selected = item);
                                widget.onSelected(item);
                                _removeOverlay();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                color: isSelected
                                    ? Colors.blue.withValues(alpha: .1)
                                    : null,
                                child: Text(
                                  widget.itemLabel(item),
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
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
    final selectedValue = _selected != null
        ? widget.itemLabel(_selected as T)
        : "---";

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
