import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/core.dart';

class PasswordFieldWidget extends StatefulWidget {
  final Widget? label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const PasswordFieldWidget({
    super.key,
    this.label,
    this.controller,
    this.validator,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction,
  });

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return CustomInput(
      controller: widget.controller,
      lable: widget.label,
      prefixIcon: const Icon(Icons.lock_outline),
      obscureText: !isVisible,
      suffixIcon: InkWell(
        onTap: () => setState(() => isVisible = !isVisible),
        child: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
      ),
      validator: widget.validator,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
    );
  }
}
