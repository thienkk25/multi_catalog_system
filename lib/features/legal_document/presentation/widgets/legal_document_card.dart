import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/custom_alert_dialog.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_label.dart';
import 'package:multi_catalog_system/core/widgets/role_based_widget.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entries/legal_document_entry.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_bloc.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_event.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/pages/legal_document_form_page.dart';

class LegalDocumentCard extends StatelessWidget {
  final LegalDocumentEntry entry;

  const LegalDocumentCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  entry.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              CustomLabel(
                text: _statusText(entry.status),
                color: _statusColor(entry.status),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              _TypeChip(type: entry.type),
              const SizedBox(width: 8),
              Text(
                entry.code,
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const Divider(height: 24, thickness: 1, color: Color(0xFFD1D5DB)),

          _InfoRow(
            icon: Icons.person_2_outlined,
            label: 'Người ban hành',
            value: entry.issuedByName ?? '—',
          ),
          _InfoRow(
            icon: Icons.event_note_outlined,
            label: 'Ngày ban hành',
            value: _formatDate(entry.issueDate),
          ),
          _InfoRow(
            icon: Icons.flash_on_outlined,
            label: 'Hiệu lực',
            value:
                '${_formatDate(entry.effectiveDate)} → ${_formatDate(entry.expiryDate)}',
          ),

          if ((entry.description ?? '').isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              entry.description!,
              style: const TextStyle(color: Color(0xFF4B5563), height: 1.4),
            ),
          ],

          const SizedBox(height: 16),

          if (entry.fileUrl != null && entry.fileName != null)
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                print('open file');
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.withValues(alpha: .5)),
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    _getFileIcon(entry.fileName!),
                    Expanded(
                      child: Text(
                        entry.fileName!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        print('download');
                      },
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
          const SizedBox(height: 10),
          RoleBasedWidget(
            permission: ['admin'],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 8,
              children: [
                _ActionButton(
                  icon: Icons.edit_outlined,
                  label: 'Sửa',
                  color: const Color(0xFF2563EB),
                  onPressed: () {
                    context.pushNamed(
                      RouterNames.legalDocumentForm,
                      extra: {
                        'bloc': context.read<LegalDocumentBloc>(),
                        'type': LegalDocumentFormPageType.update,
                        'entry': entry,
                      },
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.delete_outline,
                  label: 'Xóa',
                  color: const Color(0xFFDC2626),
                  onPressed: () {
                    final bloc = context.read<LegalDocumentBloc>();
                    showDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                        onConfirm: () {
                          context.pop();
                          bloc.add(LegalDocumentEvent.delete(id: entry.id!));
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Vĩnh viễn';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _statusText(String? status) {
    switch (status) {
      case 'active':
        return 'Hiệu lực';
      case 'expired':
        return 'Hết hiệu lực';
      case 'replaced':
        return 'Đã được thay thế';
      case 'revoked':
        return 'Bị thu hồi';
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

class _TypeChip extends StatelessWidget {
  final String type;
  const _TypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _typeColor(String type) {
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6B7280)),
          const SizedBox(width: 6),
          Text('$label: ', style: const TextStyle(color: Color(0xFF6B7280))),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: Text(label, style: TextStyle(color: color)),
    );
  }
}
