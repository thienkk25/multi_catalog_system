import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.child, this.color});
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color ?? Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(padding: const EdgeInsets.all(15.0), child: child),
    );
  }
}
