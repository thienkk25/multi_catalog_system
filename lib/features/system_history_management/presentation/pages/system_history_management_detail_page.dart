import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/formatter/data_time_formatter.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/entities/system_history_entry.dart';
import 'package:multi_catalog_system/features/system_history_management/presentation/bloc/system_history_bloc.dart';
import 'package:multi_catalog_system/features/system_history_management/presentation/bloc/system_history_state.dart';

class SystemHistoryManagementDetailPage extends StatelessWidget {
  const SystemHistoryManagementDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết lịch sử hệ thống',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SystemHistoryBloc, SystemHistoryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CustomCircularProgressScreen());
          }

          if (state.error != null) {
            return const Center(child: Text('Xảy ra lỗi'));
          }

          final entry = state.entries.firstOrNull;
          if (entry == null) {
            return const Center(child: Text('Không tìm thấy dữ liệu'));
          }

          final oldData =
              (entry.metadata['old'] as Map<String, dynamic>?) ?? const {};
          final newData =
              (entry.metadata['new'] as Map<String, dynamic>?) ?? const {};

          final changedKeys = {
            ...oldData.keys,
            ...newData.keys,
          }.where((k) => oldData[k]?.toString() != newData[k]?.toString());

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(entry),
                  const SizedBox(height: 16),
                  _buildDiffCard(
                    entry: entry,
                    oldData: oldData,
                    newData: newData,
                    changedKeys: changedKeys,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(SystemHistoryEntry entry) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionBadge(entry),
          const SizedBox(height: 12),
          _buildInfoRow('Endpoint', entry.endpoint),
          _buildInfoRow('User ID', entry.userId ?? 'System'),
          _buildInfoRow('Thời gian', dateTimeFormatFull(entry.timestamp)),
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

  Widget _buildActionBadge(SystemHistoryEntry entry) {
    final color = _actionColor(entry.action);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${entry.action} · ${entry.method}',
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

  Widget _buildDiffCard({
    required SystemHistoryEntry entry,
    required Map<String, dynamic> oldData,
    required Map<String, dynamic> newData,
    required Iterable<String> changedKeys,
  }) {
    if (changedKeys.isEmpty) {
      final fields = entry.metadata as Map<String, dynamic>? ?? {};

      return CustomCard(
        child: Column(
          children: [
            _buildSingleHeader(),
            const Divider(),
            ...fields.entries.map(
              (e) => _buildSingleRow(
                keyName: e.key,
                value: e.value,
                color: _actionColor(entry.action),
              ),
            ),
          ],
        ),
      );
    }

    return CustomCard(
      child: Column(
        children: [
          _buildDiffHeader(),
          const Divider(),
          ...changedKeys.map(
            (key) => _buildDiffRow(
              field: key,
              oldValue: oldData[key],
              newValue: newData[key],
              actionColor: _actionColor(entry.action),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleHeader() {
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
          child: Text('Dữ liệu', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildSingleRow({
    required String keyName,
    required dynamic value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              keyName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(formatValue(value), style: TextStyle(color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildDiffHeader() {
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
    required Color actionColor,
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
              formatValue(oldValue),
              style: const TextStyle(color: Color(0xFF9CA3AF)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              formatValue(newValue),
              style: TextStyle(color: actionColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
