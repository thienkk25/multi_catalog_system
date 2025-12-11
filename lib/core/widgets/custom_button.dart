import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.colorBackground,
    required this.textButton,
    this.colorBorder,
  });
  final Function() onTap;
  final Color colorBackground;
  final Color? colorBorder;
  final Widget textButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: colorBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorBorder ?? Colors.transparent),
        ),
        child: Center(child: textButton),
      ),
    );
  }
}
