import 'package:flutter/material.dart';

import 'custom_button.dart';

class ErrorRetryWidget extends StatelessWidget {
  const ErrorRetryWidget({super.key, required this.error, this.onRetry});
  final String error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        Text(error, style: TextStyle(color: Colors.red)),
        SizedBox(
          width: 150,
          child: CustomButton(
            onTap: onRetry,
            colorBackground: Colors.red,
            textButton: Text('Thử lại', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
