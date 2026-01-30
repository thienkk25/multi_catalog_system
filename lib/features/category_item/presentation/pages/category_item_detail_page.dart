import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/utils/formatter/data_time_formatter.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/file_icon_widget.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';
import 'package:multi_catalog_system/features/category_item/presentation/widgets/category_item_status_chip.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryItemDetailPage extends StatefulWidget {
  final CategoryItemEntry entry;
  final bool isAdmin;

  const CategoryItemDetailPage({
    super.key,
    required this.entry,
    this.isAdmin = false,
  });

  @override
  State<CategoryItemDetailPage> createState() => _CategoryItemDetailPageState();
}

class _CategoryItemDetailPageState extends State<CategoryItemDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.name ?? 'Thông tin danh mục'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          dividerColor: Colors.grey,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Thông tin'),
            Tab(text: 'Lịch sử phiên bản'),
            Tab(text: 'Phê duyệt'),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          _InfoTab(entry: entry),
          _HistoryTab(entry: entry),
          _ApprovalTab(entry: entry),
        ],
      ),

      bottomNavigationBar: widget.isAdmin ? _AdminActions(entry: entry) : null,
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
                  CategoryItemStatusChip(status: entry.status!),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        CustomCard(
          child: Column(
            children: [
              _InfoRow(label: 'Mã danh mục', value: entry.code!),
              _InfoRow(label: 'Tên danh mục', value: entry.name!),
              if (entry.description?.isNotEmpty == true)
                _InfoRow(
                  label: 'Mô tả',
                  value: entry.description!,
                  multiline: true,
                ),
              _InfoRow(label: 'Lĩnh vực', value: entry.domainName!),
              _InfoRow(label: 'Nhóm danh mục', value: entry.groupName!),
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
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return CustomCard(
          child: ListTile(
            leading: const Icon(Icons.history),
            title: Text('Phiên bản ${3 - index}'),
            subtitle: const Text('Cập nhật mô tả danh mục'),
            trailing: Text(dateFormat(DateTime.now())),
          ),
        );
      },
    );
  }
}

class _ApprovalTab extends StatelessWidget {
  final CategoryItemEntry entry;
  const _ApprovalTab({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.verified, size: 40, color: Colors.green),
              SizedBox(height: 12),
              Text(
                'Danh mục đã được phê duyệt',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminActions extends StatelessWidget {
  final CategoryItemEntry entry;
  const _AdminActions({required this.entry});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Khôi phục phiên bản'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Chỉnh sửa'),
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
  final String value;
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
              value,
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
