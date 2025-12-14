import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    this.lable,
    this.hintText,
    this.controller,
    this.icon,
    this.maxLines,
    this.minLines,
    this.enabled,
  });
  final Widget? lable;
  final String? hintText;
  final TextEditingController? controller;
  final Widget? icon;
  final int? minLines;
  final int? maxLines;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        ?lable,
        TextFormField(
          enabled: enabled,
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hoverColor: Colors.blue.withValues(alpha: .1),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),
            suffixIcon: icon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue.withValues(alpha: .5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          minLines: minLines ?? 1,
          maxLines: maxLines ?? 1,
        ),
      ],
    );
  }
}
