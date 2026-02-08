import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';

class ButtonBackWidget extends StatelessWidget {
  const ButtonBackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: CustomButton(
        colorBackground: Colors.white,
        colorBorder: Colors.blue.withValues(alpha: .5),
        textButton: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Icon(Icons.arrow_back, color: Colors.blue),
            Text('Quay lại'),
          ],
        ),
        onTap: () => context.pop(),
      ),
    );
  }
}
