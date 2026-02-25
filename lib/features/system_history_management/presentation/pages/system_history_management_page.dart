import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/responsive/screen_size.dart';
import 'package:multi_catalog_system/core/widgets/buttom_up_widget.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/custom_dropdown_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/error_retry_widget.dart';
import 'package:multi_catalog_system/features/system_history_management/presentation/presentation.dart';

class SystemHistoryManagementPage extends StatefulWidget {
  const SystemHistoryManagementPage({super.key});

  @override
  State<SystemHistoryManagementPage> createState() =>
      _SystemHistoryManagementPageState();
}

class _SystemHistoryManagementPageState
    extends State<SystemHistoryManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  late ValueNotifier<bool> _showUpButton;
  late final SystemHistoryBloc bloc;

  @override
  void initState() {
    super.initState();
    _showUpButton = ValueNotifier(false);
    bloc = context.systemHistoryBloc;
    bloc.add(const SystemHistoryEvent.getAll());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final shouldShow = _scrollController.offset > 300;

    if (_showUpButton.value != shouldShow) {
      _showUpButton.value = shouldShow;
    }
    if (!bloc.state.hasMore) return;
    if (bloc.state.isLoadingMore) return;

    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      bloc.add(const SystemHistoryEvent.loadMore());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            if (!ScreenSize.of(context).isMobile)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: const Text(
                    'Nhật kí hệ thống',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: _buildSearchFilterSection(context),
              ),
            ),
            BlocBuilder<SystemHistoryBloc, SystemHistoryState>(
              buildWhen: (previous, current) =>
                  previous.entries != current.entries ||
                  previous.isLoading != current.isLoading,
              builder: (context, state) {
                if (state.isLoading) {
                  return SliverFillRemaining(
                    child: const Center(child: CustomCircularProgressScreen()),
                  );
                }

                if (state.error != null) {
                  return SliverFillRemaining(
                    child: ErrorRetryWidget(
                      error: state.error!,
                      onRetry: () {
                        bloc.add(const SystemHistoryEvent.getAll());
                      },
                    ),
                  );
                }

                if (state.entries.isEmpty) {
                  return SliverFillRemaining(
                    child: const Center(child: Text('Không có dữ liệu')),
                  );
                }

                final entries = state.entries;
                if (ScreenSize.of(context).isMobile ||
                    ScreenSize.of(context).isTablet) {
                  return SliverList.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SystemHistoryManagementCard(log: entry),
                      );
                    },
                  );
                }
                return SliverToBoxAdapter(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = (constraints.maxWidth / 600)
                          .floor()
                          .clamp(1, 6);

                      final itemWidth =
                          constraints.maxWidth / crossAxisCount - 10;

                      return Column(
                        children: [
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ...entries.map(
                                (entry) => SizedBox(
                                  width: itemWidth,
                                  child: SystemHistoryManagementCard(
                                    log: entry,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
            BlocBuilder<SystemHistoryBloc, SystemHistoryState>(
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
              scrollController: _scrollController,
              show: show,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchFilterSection(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomInput(
          hintText: 'Tìm kiếm...',
          suffixIcon: const Icon(Icons.search),
          onChanged: (value) {
            final search = value.trim();
            if (_debounce?.isActive ?? false) {
              _debounce?.cancel();
            }
            _debounce = Timer(const Duration(milliseconds: 500), () {
              if (search.isEmpty) {
                bloc.add(const SystemHistoryEvent.getAll());
              } else {
                bloc.add(SystemHistoryEvent.getAll(search: search));
              }
            });
          },
        ),
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterButton(
                context: context,
                label: 'Tất cả',
                onTap: () => bloc.add(
                  const SystemHistoryEvent.getAll(
                    sortBy: 'timestamp',
                    sort: 'desc',
                  ),
                ),
              ),
              _buildFilterButton(
                context: context,
                label: 'Tạo',
                onTap: () => bloc.add(
                  SystemHistoryEvent.getAll(
                    search: bloc.state.search,
                    filter: {'action': 'INSERT'},
                    sortBy: bloc.state.sortBy,
                    sort: bloc.state.sort,
                  ),
                ),
              ),
              _buildFilterButton(
                context: context,
                label: 'Cập nhật',
                onTap: () => bloc.add(
                  SystemHistoryEvent.getAll(
                    search: bloc.state.search,
                    filter: {'action': 'UPDATE'},
                    sortBy: bloc.state.sortBy,
                    sort: bloc.state.sort,
                  ),
                ),
              ),
              _buildFilterButton(
                context: context,
                label: 'Xóa',
                onTap: () => bloc.add(
                  SystemHistoryEvent.getAll(
                    search: bloc.state.search,
                    filter: {'action': 'DELETE'},
                    sortBy: bloc.state.sortBy,
                    sort: bloc.state.sort,
                  ),
                ),
              ),

              SizedBox(
                width: 250,
                child: CustomDropdownButton<String>(
                  value: 'timestamp|desc',
                  items: const [
                    DropdownMenuItem(
                      value: 'action|asc',
                      child: Text('Hành động (A → Z)'),
                    ),
                    DropdownMenuItem(
                      value: 'action|desc',
                      child: Text('Hành động (Z → A)'),
                    ),
                    DropdownMenuItem(
                      value: 'method|asc',
                      child: Text('Loại đối tượng (A → Z)'),
                    ),
                    DropdownMenuItem(
                      value: 'method|desc',
                      child: Text('Loại đối tượng (Z → A)'),
                    ),
                    DropdownMenuItem(
                      value: 'timestamp|desc',
                      child: Text('Mới nhất'),
                    ),
                    DropdownMenuItem(
                      value: 'timestamp|asc',
                      child: Text('Cũ nhất'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;

                    final parts = value.split('|');
                    bloc.add(
                      SystemHistoryEvent.getAll(
                        search: bloc.state.search,
                        sortBy: parts[0],
                        sort: parts[1],
                        filter: bloc.state.filter,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child:
            BlocSelector<
              SystemHistoryBloc,
              SystemHistoryState,
              Map<String, dynamic>?
            >(
              selector: (state) => state.filter,
              builder: (context, state) {
                final isSelected =
                    (state != null && state['action'] == _actionText(label)) ||
                    (state == null && label == 'Tất cả');
                return Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: .5),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }

  String _actionText(String label) {
    switch (label) {
      case 'Tạo':
        return 'INSERT';
      case 'Cập nhật':
        return 'UPDATE';
      case 'Xóa':
        return 'DELETE';
      default:
        return '';
    }
  }
}
