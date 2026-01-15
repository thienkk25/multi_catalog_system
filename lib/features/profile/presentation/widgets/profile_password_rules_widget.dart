import 'package:flutter/material.dart';

class ProfilePasswordRulesWidget extends StatelessWidget {
  final String password;

  const ProfilePasswordRulesWidget({super.key, required this.password});

  bool get hasMinLength => password.length >= 8;
  bool get hasUppercase => RegExp(r'[A-Z]').hasMatch(password);
  bool get hasNumber => RegExp(r'\d').hasMatch(password);

  @override
  Widget build(BuildContext context) {
    final successColor = Colors.green;
    final errorColor = Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RuleItem(
          text: 'Ít nhất 8 ký tự',
          isValid: hasMinLength,
          successColor: successColor,
          errorColor: errorColor,
        ),
        _RuleItem(
          text: 'Có ít nhất 1 chữ hoa',
          isValid: hasUppercase,
          successColor: successColor,
          errorColor: errorColor,
        ),
        _RuleItem(
          text: 'Có ít nhất 1 chữ số',
          isValid: hasNumber,
          successColor: successColor,
          errorColor: errorColor,
        ),
      ],
    );
  }
}

class _RuleItem extends StatelessWidget {
  final String text;
  final bool isValid;
  final Color successColor;
  final Color errorColor;

  const _RuleItem({
    required this.text,
    required this.isValid,
    required this.successColor,
    required this.errorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          size: 18,
          color: isValid ? successColor : errorColor,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: isValid ? successColor : errorColor),
        ),
      ],
    );
  }
}
