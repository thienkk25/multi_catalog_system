import 'package:flutter/material.dart';

class CustomCircularProgressButton extends StatelessWidget {
  final Color? color;
  final double size;
  final double strokeWidth;

  const CustomCircularProgressButton({
    super.key,
    this.size = 20,
    this.strokeWidth = 2,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color ?? Colors.white,
      ),
    );
  }
}

class CustomCircularProgressScreen extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;
  final Color backgroundColor;

  const CustomCircularProgressScreen({
    super.key,
    this.color = Colors.white,
    this.size = 36,
    this.strokeWidth = 3,
    this.backgroundColor = const Color(0x33000000),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + 20,
      height: size + 20,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: color,
        ),
      ),
    );
  }
}

class CustomCircularProgressLoadMore extends StatelessWidget {
  const CustomCircularProgressLoadMore({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 8,
              ),
            ],
          ),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
