import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/formatter/data_time_formatter.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_bloc.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_state.dart';

class CategoryGroupDetailPage extends StatelessWidget {
  const CategoryGroupDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết nhóm danh mục'),
        centerTitle: true,
      ),
      body: BlocBuilder<CategoryGroupBloc, CategoryGroupState>(
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
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _sectionCard(
                    title: 'Thông tin nhóm danh mục',
                    icon: Icons.folder_outlined,
                    children: [
                      _infoRow(label: 'Mã nhóm', value: entry.code),
                      _infoRow(label: 'Tên nhóm', value: entry.name),
                      _infoRow(
                        label: 'Mô tả',
                        value: entry.description,
                        isMultiLine: true,
                      ),
                      _infoRow(label: 'Domain ID', value: entry.domainId),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _sectionCard(
                    title: 'Thông tin hệ thống',
                    icon: Icons.info_outline,
                    children: [
                      _metaRow('Ngày tạo', entry.createdAt),
                      _metaRow('Cập nhật lần cuối', entry.updatedAt),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blueGrey),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow({
    required String label,
    String? value,
    bool isMultiLine = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value?.isNotEmpty == true ? value! : '-',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            maxLines: isMultiLine ? null : 1,
            overflow: isMultiLine
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _metaRow(String label, DateTime? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Text(
            dateTimeFormat(value),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
