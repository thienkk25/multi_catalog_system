import 'package:flutter/material.dart';

import 'custom_button.dart';

class BottomFormActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const BottomFormActions({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: .5),
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                onTap: onCancel,
                colorBackground: Colors.white,
                colorBorder: Colors.blue.withValues(alpha: .5),
                textButton: const Text(
                  'Hủy',
                  style: TextStyle(fontWeight: FontWeight(600)),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CustomButton(
                onTap: onSave,
                colorBackground: Colors.blue,
                textButton: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.save, size: 20, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      'Lưu',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight(600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
