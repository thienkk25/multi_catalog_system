import 'package:flutter/material.dart';
import 'screen_size.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize screen) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final screen = ScreenSize.of(context);
    return builder(context, screen);
  }
}
