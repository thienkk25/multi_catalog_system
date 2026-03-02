import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';

import 'package:multi_catalog_system/core/utils/formatter/data_time_formatter.dart';
import 'package:multi_catalog_system/core/widgets/button_back_widget.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/bloc/api_key_bloc.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/bloc/api_key_state.dart';

class ApiKeyManagementDetailPage extends StatelessWidget {
  const ApiKeyManagementDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiKeyBloc, ApiKeyState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CustomCircularProgressScreen());
        }
        if (state.error != null) {
          return const Center(child: Text('Xảy ra lỗi'));
        }
        final entry = state.entry;
        if (entry == null) {
          return const Center(child: Text('Không tìm thấy dữ liệu'));
        }
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ApiKeyBox(apiKey: entry.key ?? ''),
                const SizedBox(height: 16),
                CustomCard(
                  child: Column(
                    children: [
                      _InfoRow(label: 'Tên', value: entry.systemName ?? '-'),
                      _InfoRow(
                        label: 'Trạng thái',
                        value: _actionText(entry.status ?? '-'),
                        valueColor: _actionColor(entry.status ?? ''),
                      ),
                      _InfoRow(
                        label: 'Lĩnh vực cho phép',
                        value:
                            entry.allowedDomains
                                ?.map((e) => e.name)
                                .join(', ') ??
                            '-',
                      ),
                      _InfoRow(
                        label: 'Ngày tạo',
                        value: dateTimeFormatFull(entry.createdAt),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  spacing: 5,
                  children: [
                    Expanded(child: ButtonBackWidget()),
                    Expanded(
                      child: CustomButton(
                        colorBackground: Colors.blue,
                        textButton: const Text(
                          'Sao chép API Key',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () => _copyToClipboard(context, entry.key ?? ''),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    context.notificationCubit.success('Sao chép API Key thành công');
  }

  Color _actionColor(String action) {
    switch (action) {
      case 'active':
        return Colors.green;
      case 'revoked':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _actionText(String action) {
    switch (action) {
      case 'active':
        return 'Hoạt động';
      case 'revoked':
        return 'Thu hồi';
      default:
        return 'Thu hồi';
    }
  }
}

class _ApiKeyBox extends StatefulWidget {
  final String apiKey;

  const _ApiKeyBox({required this.apiKey});

  @override
  State<_ApiKeyBox> createState() => _ApiKeyBoxState();
}

class _ApiKeyBoxState extends State<_ApiKeyBox> {
  bool _isShow = false;
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'API Key',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SelectableText(
                    _isShow ? widget.apiKey : _getHintKey(widget.apiKey),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(_isShow ? Icons.visibility : Icons.visibility_off),
                  tooltip: _isShow ? 'Ẩn API Key' : 'Hiển thị API Key',
                  onPressed: () {
                    setState(() => _isShow = !_isShow);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getHintKey(String key) {
    final start = key.substring(0, 7);
    final end = key.substring(key.length - 4);
    return '$start...$end';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
