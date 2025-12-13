import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/core.dart';

class LegalDocumentListViewWidget extends StatelessWidget {
  const LegalDocumentListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      itemBuilder: (context, index) {
        final docType = 'Thông tư';
        final typeColor = getDocTypeColor(docType);

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
                      'Văn bản pháp luật ${index + 1}',
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
                      color: typeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      docType,
                      style: TextStyle(
                        color: typeColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'VBPL-${1000 + index}',
                    style: const TextStyle(
                      color: Color(0xFF005BAC),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              Text(
                'Mô tả ngắn về văn bản pháp luật này.',
                style: const TextStyle(color: Color(0xFF6B7280)),
              ),

              Text(
                'Ngày ban hành: 01/01/2026',
                style: const TextStyle(color: Color(0xFF6B7280)),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
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
                      child: const Text(
                        'Xem tài liệu',
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
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 10);
      },
    );
  }
}

Color getDocTypeColor(String type) {
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
