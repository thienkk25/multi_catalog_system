import 'package:flutter/material.dart';

class ButtomUpWidget extends StatelessWidget {
  final ScrollController scrollController;
  final bool show;

  const ButtomUpWidget({
    super.key,
    required this.scrollController,
    required this.show,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 120,
      child: IgnorePointer(
        ignoring: !show,
        child: GestureDetector(
          onTap: () {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            offset: show ? Offset.zero : const Offset(0, 1.5),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: show ? 1 : 0,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(blurRadius: 8, color: Colors.black26),
                  ],
                ),
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
