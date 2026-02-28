import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/utils/formatter/data_time_formatter.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/file_icon_widget.dart';
import 'package:multi_catalog_system/core/widgets/role_based_widget.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_state.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_event.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_state.dart';
import 'package:multi_catalog_system/features/category_item/presentation/widgets/category_item_status_chip.dart';
import 'package:multi_catalog_system/features/category_item/presentation/widgets/category_item_version_history_card.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryItemDetailPage extends StatefulWidget {
  const CategoryItemDetailPage({super.key});

  @override
  State<CategoryItemDetailPage> createState() => _CategoryItemDetailPageState();
}

class _CategoryItemDetailPageState extends State<CategoryItemDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryItemBloc, CategoryItemState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.error != null) {
          return Scaffold(body: Center(child: Text(state.error!)));
        }

        final entry = state.entry;

        if (entry == null) {
          return const Scaffold(body: Center(child: Text('Không có dữ liệu')));
        }

        context.itemVersionBloc.add(
          CategoryItemVersionEvent.getHistoryVersion(itemId: entry.id!),
        );

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              dividerColor: Colors.grey,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(text: 'Thông tin'),
                Tab(text: 'Lịch sử phiên bản'),
              ],
            ),
          ),

          body: TabBarView(
            controller: _tabController,
            children: [
              _InfoTab(entry: entry),
              _HistoryTab(entry: entry),
            ],
          ),

          bottomNavigationBar: _BottomActions(entry: entry),
        );
      },
    );
  }
}

class _InfoTab extends StatelessWidget {
  final CategoryItemEntry entry;
  const _InfoTab({required this.entry});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CustomCard(
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Trạng thái',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  CategoryItemStatusChip(status: entry.status ?? '-'),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        CustomCard(
          child: Column(
            children: [
              _InfoRow(label: 'Mã danh mục', value: entry.code),
              _InfoRow(label: 'Tên danh mục', value: entry.name),
              if (entry.description?.isNotEmpty == true)
                _InfoRow(
                  label: 'Mô tả',
                  value: entry.description!,
                  multiline: true,
                ),
              _InfoRow(label: 'Lĩnh vực', value: entry.domain?.name),
              _InfoRow(label: 'Nhóm danh mục', value: entry.group?.name),
              _InfoRow(label: 'Người tạo', value: entry.createdByName),
              _InfoRow(
                label: 'Người cập nhật gần đây',
                value: entry.updatedByName,
              ),
              _InfoRow(label: 'Ngày tạo', value: dateFormat(entry.createdAt)),
            ],
          ),
        ),

        const SizedBox(height: 12),

        if (entry.legalDocuments != null && entry.legalDocuments!.isNotEmpty)
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Văn bản pháp lý liên quan',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: entry.legalDocuments?.length ?? 0,
                  itemBuilder: (context, index) {
                    final legalDocument = entry.legalDocuments?[index];
                    return _LegalItem(legalDocument: legalDocument);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _HistoryTab extends StatelessWidget {
  final CategoryItemEntry entry;
  const _HistoryTab({required this.entry});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryItemVersionBloc, CategoryItemVersionState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(child: Text(state.error!));
        }
        final entries = state.entries;

        if (entries.isEmpty) {
          return const Center(child: Text('Không có lịch sử'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final indexVersion = entries.length - 1 - index;
            final entry = entries[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CategoryItemVersionHistoryCard(
                entry: entry,
                indexVersion: indexVersion,
              ),
            );
          },
        );
      },
    );
  }
}

class _BottomActions extends StatelessWidget {
  final CategoryItemEntry entry;
  const _BottomActions({required this.entry});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 60,
        child: Row(
          spacing: 5,
          children: [
            Expanded(
              child: CustomButton(
                onTap: () {
                  context.pop();
                },
                colorBackground: Colors.transparent,
                colorBorder: Colors.blue.withValues(alpha: .5),
                textButton: const Text(
                  'Quay lại',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            RoleBasedWidget(
              permission: ['admin', 'domainOfficer'],
              child: Expanded(
                child: CustomButton(
                  onTap: () {
                    context.goNamed(
                      RouterNames.categoryItemForm,
                      queryParameters: {
                        'mode': 'updateItem',
                        'itemId': entry.id.toString(),
                      },
                    );
                  },
                  colorBackground: Colors.blue,
                  textButton: const Text(
                    'Chỉnh sửa',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final bool multiline;

  const _InfoRow({
    required this.label,
    required this.value,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: multiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalItem extends StatelessWidget {
  final LegalDocumentEntry? legalDocument;
  const _LegalItem({required this.legalDocument});

  @override
  Widget build(BuildContext context) {
    if (legalDocument == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          final uri = Uri.parse(legalDocument!.fileUrl!);
          await launchUrl(uri);
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
              FileIconWidget(fileName: legalDocument!.fileName!),
              Expanded(
                child: Text(
                  legalDocument!.fileName!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
