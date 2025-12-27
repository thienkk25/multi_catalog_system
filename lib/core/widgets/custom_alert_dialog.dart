import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final VoidCallback? onConfirm;
  const CustomAlertDialog({super.key, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.redAccent,
            size: 28,
          ),
          const SizedBox(width: 8),
          const Text(
            'Xác nhận xóa',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: const Text(
        'Bạn có chắc chắn muốn xóa?\n'
        'Hành động này không thể hoàn tác.',
        style: TextStyle(height: 1.4),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Xóa'),
        ),
      ],
    );
  }
}
