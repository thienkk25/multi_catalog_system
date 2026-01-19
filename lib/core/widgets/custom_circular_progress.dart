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
