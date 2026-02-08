import 'package:flutter/material.dart';
import 'breakpoints.dart';

class ScreenSize {
  final double width;
  final double height;

  const ScreenSize({required this.width, required this.height});

  factory ScreenSize.of(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScreenSize(width: size.width, height: size.height);
  }

  bool get isMobile => width < Breakpoints.mobile;

  bool get isTablet =>
      width >= Breakpoints.mobile && width < Breakpoints.desktop;

  bool get isDesktop => width >= Breakpoints.desktop;
}
