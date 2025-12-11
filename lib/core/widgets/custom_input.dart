import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    this.lable,
    this.hintText,
    this.controller,
    this.icon,
  });
  final Widget? lable;
  final String? hintText;
  final TextEditingController? controller;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        ?lable,
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: icon,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
