import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/entities/system_history_entry.dart';

class SystemHistoryDetailView extends StatelessWidget {
  final SystemHistoryEntry log;

  const SystemHistoryDetailView({super.key, required this.log});

  Map<String, dynamic> get oldData =>
      (log.metadata['old'] as Map<String, dynamic>?) ?? const {};

  Map<String, dynamic> get newData =>
      (log.metadata['new'] as Map<String, dynamic>?) ?? const {};

  @override
  Widget build(BuildContext context) {
    final changedKeys = {
      ...oldData.keys,
      ...newData.keys,
    }.where((k) => oldData[k]?.toString() != newData[k]?.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết lịch sử hệ thống',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [_buildHeaderCard(), _buildDiffCard(changedKeys)],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionBadge(),
          const SizedBox(height: 12),
          _buildInfoRow('Endpoint', log.endpoint),
          _buildInfoRow('User ID', log.userId ?? 'System'),
          _buildInfoRow('Thời gian', _formatDateTime(log.timestamp)),
        ],
      ),
    );
  }

  Color _actionColor(String action) {
    switch (action) {
      case 'UPDATE':
        return Colors.green;
      case 'DELETE':
        return Colors.red;
      case 'LOGIN':
        return Colors.green;
      case 'LOGOUT':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget _buildActionBadge() {
    final color = _actionColor(log.action);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${log.action} · ${log.method}',
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiffCard(Iterable<String> keys) {
    if (keys.isEmpty) {
      final fields = log.metadata as Map<String, dynamic>? ?? {};

      return CustomCard(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Thuộc tính',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Dữ liệu',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const Divider(),
            ...fields.entries.map((e) {
              final key = e.key;
              final value = e.value;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        key,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        _formatValue(value),
                        style: TextStyle(color: _actionColor(log.action)),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    }

    return CustomCard(
      child: Column(
        children: [
          _buildTableHeader(),
          const Divider(),
          ...keys.map(
            (key) => _buildDiffRow(
              field: key,
              oldValue: oldData[key],
              newValue: newData[key],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Thuộc tính',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            'Dữ liệu cũ',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            'Dữ liệu mới',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildDiffRow({
    required String field,
    required dynamic oldValue,
    required dynamic newValue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              field,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              _formatValue(oldValue),
              style: const TextStyle(color: Color(0xFF9CA3AF)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              _formatValue(newValue),
              style: TextStyle(
                color: _actionColor(log.action),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime.toLocal());
  }

  String _formatValue(dynamic value) {
    if (value == null) return 'null';

    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return DateFormat('yyyy-MM-dd HH:mm:ss').format(parsed.toLocal());
      }
    }

    return value.toString();
  }
}
