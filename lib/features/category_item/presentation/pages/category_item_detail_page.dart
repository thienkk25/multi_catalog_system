import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/responsive/screen_size.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/utils/formatter/data_time_formatter.dart';
import 'package:multi_catalog_system/core/widgets/buttom_up_widget.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/file_icon_widget.dart';
import 'package:multi_catalog_system/core/widgets/role_based_widget.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_event.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_state.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_event.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_state.dart';
import 'package:multi_catalog_system/features/category_item/presentation/widgets/category_item_status_chip.dart';
import 'package:multi_catalog_system/features/category_item/presentation/widgets/category_item_version_history_card.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryItemDetailPage extends StatefulWidget {
  final String id;
  const CategoryItemDetailPage({super.key, required this.id});

  @override
  State<CategoryItemDetailPage> createState() => _CategoryItemDetailPageState();
}

class _CategoryItemDetailPageState extends State<CategoryItemDetailPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final AnimationController _refreshController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    context.itemBloc.add(CategoryItemEvent.getById(id: widget.id));
  }

  void _onRefresh() {
    context.itemBloc.add(CategoryItemEvent.getById(id: widget.id));

    _refreshController.forward(from: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: CustomScrollView(
        slivers: [
          if (!ScreenSize.of(context).isMobile)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Thông tin chi tiết mục danh mục',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: _onRefresh,
                      child: Row(
                        children: [
                          RotationTransition(
                            turns: _refreshController,
                            child: const Icon(Icons.refresh),
                          ),
                          const SizedBox(width: 4),
                          const Text('Làm mới'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          BlocConsumer<CategoryItemBloc, CategoryItemState>(
            listenWhen: (previous, current) =>
                previous.entry?.id != current.entry?.id &&
                current.entry != null,
            listener: (context, state) {
              context.read<CategoryItemVersionBloc>().add(
                CategoryItemVersionEvent.getHistoryVersion(
                  itemId: state.entry!.id!,
                ),
              );
            },
            builder: (context, state) {
              if (state.isLoading) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CustomCircularProgressScreen()),
                );
              }

              if (state.error != null) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text(state.error!)),
                );
              }

              final entry = state.entry;

              if (entry == null) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('Không có dữ liệu')),
                );
              }

              return SliverFillRemaining(
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      indicatorWeight: 4,
                      tabs: const [
                        Tab(text: 'Thông tin'),
                        Tab(text: 'Lịch sử phiên bản'),
                      ],
                    ),

                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _InfoTab(entry: entry),
                          _HistoryTab(entry: entry),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      bottomNavigationBar: BlocBuilder<CategoryItemBloc, CategoryItemState>(
        builder: (context, state) {
          if (state.entry == null) return const SizedBox();
          return _BottomActions(entry: state.entry!);
        },
      ),
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

class _HistoryTab extends StatefulWidget {
  final CategoryItemEntry entry;
  const _HistoryTab({required this.entry});

  @override
  State<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<_HistoryTab> {
  final ScrollController _scrollHistoryController = ScrollController();
  late ValueNotifier<bool> _showUpButton;

  @override
  void initState() {
    super.initState();
    _showUpButton = ValueNotifier(false);
    _scrollHistoryController.addListener(_onScroll);
  }

  void _onScroll() {
    final bloc = context.itemVersionBloc;
    if (!_scrollHistoryController.hasClients) return;
    final shouldShow = _scrollHistoryController.offset > 300;

    if (_showUpButton.value != shouldShow) {
      _showUpButton.value = shouldShow;
    }
    if (!bloc.state.hasMore) return;
    if (bloc.state.isLoadingMore) return;

    final position = _scrollHistoryController.position;
    if (position.maxScrollExtent <= 0) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      bloc.add(const CategoryItemVersionEvent.loadMoreHistoryVersion());
    }
  }

  @override
  void dispose() {
    _scrollHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollHistoryController,
          slivers: [
            BlocBuilder<CategoryItemVersionBloc, CategoryItemVersionState>(
              buildWhen: (prev, curr) =>
                  prev.entries != curr.entries ||
                  prev.isLoading != curr.isLoading,
              builder: (context, state) {
                if (state.isLoading) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: const Center(child: CustomCircularProgressScreen()),
                  );
                }

                if (state.error != null) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text(state.error!)),
                  );
                }
                final entries = state.entries;

                if (entries.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: const Center(child: Text('Không có lịch sử')),
                  );
                }

                final lengthEntries = entries.length;

                return SliverList.builder(
                  itemCount: lengthEntries,
                  itemBuilder: (context, index) {
                    final indexVersion = lengthEntries - 1 - index;
                    final entry = entries[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CategoryItemVersionHistoryCard(
                        entry: entry,
                        indexVersion: indexVersion,
                        lengthHistory: lengthEntries,
                      ),
                    );
                  },
                );
              },
            ),
            BlocBuilder<CategoryItemVersionBloc, CategoryItemVersionState>(
              buildWhen: (p, c) => p.isLoadingMore != c.isLoadingMore,
              builder: (context, state) {
                if (!state.isLoadingMore) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }

                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CustomCircularProgressLoadMore()),
                  ),
                );
              },
            ),
          ],
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _showUpButton,
          builder: (context, show, child) {
            return ButtomUpWidget(
              scrollController: _scrollHistoryController,
              show: show,
            );
          },
        ),
      ],
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
