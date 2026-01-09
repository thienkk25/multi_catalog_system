import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_label.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entries/legal_document_entry.dart';

class LegalDocumentDetailPage extends StatelessWidget {
  final LegalDocumentEntry entry;

  const LegalDocumentDetailPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết văn bản'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _HeaderCard(entry),
              const SizedBox(height: 12),

              _InfoGrid(
                title: 'Thông tin chung',
                items: [
                  _InfoData(Icons.article, 'Loại văn bản', entry.type),
                  _InfoData(
                    Icons.person_2_outlined,
                    'Người ban hành',
                    entry.issuedByName ?? '-',
                  ),
                  _InfoData(
                    Icons.calendar_today,
                    'Ngày ban hành',
                    _formatDate(entry.issueDate),
                  ),
                  _InfoData(
                    Icons.event_available,
                    'Ngày hiệu lực',
                    _formatDate(entry.effectiveDate),
                  ),
                  _InfoData(
                    Icons.event_busy,
                    'Ngày hết hiệu lực',
                    _formatDate(entry.expiryDate),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              _ContentCard(
                title: 'Mô tả văn bản',
                icon: Icons.description,
                child: Text(
                  entry.description ?? 'Không có mô tả',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 12),
              if (entry.fileName != null)
                _ContentCard(
                  title: 'Tài liệu đính kèm',
                  icon: Icons.attach_file,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: .5),
                        ),
                      ),
                      child: Row(
                        spacing: 8,
                        children: [
                          _getFileIcon(entry.fileName!),
                          Expanded(
                            child: Text(
                              entry.fileName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SvgPicture.asset(
                                'assets/icons/download-alt-svgrepo-com.svg',
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Vĩnh viễn';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Widget _getFileIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();

    late IconData icon;
    late Color color;
    Widget? iconCustom;

    switch (ext) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;

      case 'doc':
      case 'docx':
        icon = Icons.description;
        color = Colors.blue;
        break;

      default:
        icon = Icons.insert_drive_file;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color.withValues(alpha: .15),
      ),
      child: iconCustom ?? Icon(icon, color: color),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final LegalDocumentEntry entry;

  const _HeaderCard(this.entry);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Mã: ${entry.code}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),
              ),
              CustomLabel(
                color: _statusColor(entry.status),
                text: _statusText(entry.status),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            entry.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final String title;
  final List<_InfoData> items;

  const _InfoGrid({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3.2,
            ),
            itemBuilder: (_, i) => _InfoItem(items[i]),
          ),
        ],
      ),
    );
  }
}

class _InfoData {
  final IconData icon;
  final String label;
  final String value;

  _InfoData(this.icon, this.label, this.value);
}

class _InfoItem extends StatelessWidget {
  final _InfoData data;

  const _InfoItem(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha: .5)),
      ),
      child: Row(
        children: [
          Icon(data.icon, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  data.value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _ContentCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.blue),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

String _statusText(String? status) {
  switch (status) {
    case 'active':
      return 'Hiệu lực';
    case 'expired':
      return 'Hết hiệu lực';
    case 'replaced':
      return 'Thay thế';
    case 'revoked':
      return 'Thu hồi';
    default:
      return '—';
  }
}

Color _statusColor(String? status) {
  switch (status) {
    case 'active':
      return const Color(0xFF16A34A);
    case 'expired':
      return const Color(0xFF9CA3AF);
    case 'replaced':
      return const Color(0xFF2563EB);
    case 'revoked':
      return const Color(0xFFDC2626);
    default:
      return const Color(0xFF6B7280);
  }
}
