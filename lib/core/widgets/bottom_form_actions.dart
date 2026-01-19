import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';

import 'custom_button.dart';

class BottomFormActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool isLoading;

  const BottomFormActions({
    super.key,
    required this.onCancel,
    required this.onSave,
    this.isLoading = false,
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
                onTap: isLoading ? null : onCancel,
                colorBackground: Colors.white,
                colorBorder: Colors.blue.withValues(alpha: .5),
                textButton: const Text(
                  'Hủy',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CustomButton(
                onTap: isLoading ? null : onSave,
                colorBackground: isLoading ? Colors.grey : Colors.blue,
                textButton: isLoading
                    ? const CustomCircularProgressButton()
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.save, size: 20, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            'Lưu',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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
