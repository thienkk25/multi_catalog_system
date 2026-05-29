import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'file_preview/file_preview.dart';

class FilePreviewDialog extends StatelessWidget {
  final String url;
  final String fileName;
  final String? code;
  final String? type;
  final DateTime? issueDate;

  const FilePreviewDialog({
    super.key,
    required this.url,
    required this.fileName,
    this.code,
    this.type,
    this.issueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    fileName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            if (code != null || type != null || issueDate != null) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (code != null && code!.isNotEmpty)
                    _buildMetadataTag(
                      context,
                      icon: Icons.code,
                      label: 'Mã văn bản',
                      value: code!,
                      color: const Color(0xFF2563EB),
                    ),
                  if (type != null && type!.isNotEmpty)
                    _buildMetadataTag(
                      context,
                      icon: Icons.article_outlined,
                      label: 'Loại văn bản',
                      value: type!,
                      color: const Color(0xFFD97706),
                    ),
                  if (issueDate != null)
                    _buildMetadataTag(
                      context,
                      icon: Icons.calendar_today_outlined,
                      label: 'Ngày phát hành',
                      value: DateFormat('dd/MM/yyyy').format(issueDate!),
                      color: const Color(0xFF16A34A),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            const Divider(),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FilePreviewWidget(url: url),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataTag(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

void showFilePreviewDialog(
  BuildContext context,
  String url,
  String fileName, {
  String? code,
  String? type,
  DateTime? issueDate,
}) {
  showDialog(
    context: context,
    builder: (context) => FilePreviewDialog(
      url: url,
      fileName: fileName,
      code: code,
      type: type,
      issueDate: issueDate,
    ),
  );
}
