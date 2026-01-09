import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAlertDialog extends StatelessWidget {
  final Icon? icon;
  final String? title;
  final String? content;
  final String? confirmText;
  final VoidCallback? onConfirm;
  final String? cancelText;
  final VoidCallback? onCancel;
  const CustomAlertDialog({
    super.key,
    this.onConfirm,
    this.title,
    this.content,
    this.confirmText,
    this.cancelText,
    this.onCancel,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          icon ??
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 28,
              ),
          const SizedBox(width: 8),
          Text(
            title ?? 'Xác nhận xóa',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text(
        content ??
            'Bạn có chắc chắn muốn xóa?\nHành động này không thể hoàn tác.',
        style: TextStyle(height: 1.4),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        OutlinedButton(
          onPressed: onCancel ?? () => context.pop(),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(cancelText ?? 'Hủy'),
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
          child: Text(confirmText ?? 'Xóa'),
        ),
      ],
    );
  }
}
