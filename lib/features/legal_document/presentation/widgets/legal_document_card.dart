import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_label.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entries/legal_document_entry.dart';

class LegalDocumentCard extends StatelessWidget {
  final LegalDocumentEntry entry;
  const LegalDocumentCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: Colors.white,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              CustomLabel(color: const Color(0xFF16A34A), text: 'Hiệu lực'),
            ],
          ),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getDocTypeColor(entry.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  entry.type,
                  style: TextStyle(
                    color: _getDocTypeColor(entry.type),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                entry.code,
                style: const TextStyle(
                  color: Color(0xFF005BAC),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          Text(
            entry.description ?? '',
            style: const TextStyle(color: Color(0xFF6B7280)),
          ),

          Text(
            entry.issueDate != null
                ? 'Ngày phát hành: ${DateFormat('dd/MM/yyyy').format(entry.issueDate!)}'
                : '',
            style: const TextStyle(color: Color(0xFF6B7280)),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFE6F0FA),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 6,
                  children: const [
                    Icon(
                      Icons.description_outlined,
                      size: 16,
                      color: Color(0xFF005BAC),
                    ),
                    Text(
                      'Tài liệu.pdf',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF005BAC),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    entry.fileUrl ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF6B7280)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Color(0xFFEF4444)),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getDocTypeColor(String type) {
    switch (type) {
      case 'Luật':
        return const Color(0xFFB91C1C);
      case 'Nghị định':
        return const Color(0xFF92400E);
      case 'Thông tư':
        return const Color(0xFF1D4ED8);
      default:
        return const Color(0xFF6B7280);
    }
  }
}
