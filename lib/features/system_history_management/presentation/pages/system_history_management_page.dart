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
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _refreshController;
  Timer? _debounce;
  late ValueNotifier<bool> _showUpButton;
  late final SystemHistoryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _showUpButton = ValueNotifier(false);
    _refreshController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _bloc = context.systemHistoryBloc;
    _bloc.add(
      const SystemHistoryEvent.getAll(sortBy: 'timestamp', sort: 'desc'),
    );
    _scrollController.addListener(_onScroll);
  }

  void _onRefresh() {
    _bloc.add(
      SystemHistoryEvent.getAll(
        search: _bloc.state.search,
        sortBy: _bloc.state.sortBy,
        sort: _bloc.state.sort,
      ),
    );
    _refreshController.forward(from: 0);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final shouldShow = _scrollController.offset > 300;

    if (_showUpButton.value != shouldShow) {
      _showUpButton.value = shouldShow;
    }
    if (!_bloc.state.hasMore) return;
    if (_bloc.state.isLoadingMore) return;

    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      _bloc.add(const SystemHistoryEvent.loadMore());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async => _onRefresh(),
      child: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              if (!ScreenSize.of(context).isMobile)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nhật kí hệ thống',
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
                                child: Icon(Icons.refresh),
                              ),
                              Text('Làm mới'),
                            ],
                          ),
                        ),
                      ],
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
                      hasScrollBody: false,
                      child: const Center(
                        child: CustomCircularProgressScreen(),
                      ),
                    );
                  }

                  if (state.error != null) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: ErrorRetryWidget(
                        error: state.error!,
                        onRetry: () {
                          _bloc.add(
                            const SystemHistoryEvent.getAll(
                              sortBy: 'timestamp',
                              sort: 'desc',
                            ),
                          );
                        },
                      ),
                    );
                  }

                  if (state.entries.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
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
      ),
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
                _bloc.add(
                  SystemHistoryEvent.getAll(
                    sortBy: _bloc.state.sortBy,
                    sort: _bloc.state.sort,
                    filter: _bloc.state.filter,
                  ),
                );
              } else {
                _bloc.add(
                  SystemHistoryEvent.getAll(
                    search: search,
                    sortBy: _bloc.state.sortBy,
                    sort: _bloc.state.sort,
                    filter: _bloc.state.filter,
                  ),
                );
              }
            });
          },
        ),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterButton(
                context: context,
                label: 'Tất cả',
                onTap: () => _updateFilter('action', null),
              ),
              _buildFilterButton(
                context: context,
                label: 'Tạo',
                onTap: () => _updateFilter('action', 'INSERT'),
              ),
              _buildFilterButton(
                context: context,
                label: 'Cập nhật',
                onTap: () => _updateFilter('action', 'UPDATE'),
              ),
              _buildFilterButton(
                context: context,
                label: 'Xóa',
                onTap: () => _updateFilter('action', 'DELETE'),
              ),
              const SizedBox(width: 5),
              _buildDateFilterButton(context),
              const SizedBox(width: 5),
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
                    _bloc.add(
                      SystemHistoryEvent.getAll(
                        search: _bloc.state.search,
                        sortBy: parts[0],
                        sort: parts[1],
                        filter: _bloc.state.filter,
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

  void _updateFilter(String key, String? value) {
    final currentFilter = Map<String, dynamic>.from(_bloc.state.filter ?? {});
    if (value == null) {
      currentFilter.remove(key);
    } else {
      currentFilter[key] = value;
    }
    _bloc.add(
      SystemHistoryEvent.getAll(
        search: _bloc.state.search,
        filter: currentFilter.isEmpty ? null : currentFilter,
        sortBy: _bloc.state.sortBy,
        sort: _bloc.state.sort,
      ),
    );
  }

  Widget _buildDateFilterButton(BuildContext context) {
    return BlocSelector<
      SystemHistoryBloc,
      SystemHistoryState,
      Map<String, dynamic>?
    >(
      selector: (state) => state.filter,
      builder: (context, filter) {
        final hasDateFilter =
            filter != null && filter.containsKey('timestamp_between');
        String label = 'Thời gian';
        if (hasDateFilter) {
          final dates = filter['timestamp_between'].toString().split(',');
          if (dates.length == 2) {
            final startParts = dates[0].split('-');
            final endParts = dates[1].split('-');
            if (startParts.length == 3 && endParts.length == 3) {
              label = '${startParts[2]}/${startParts[1]} - ${endParts[2]}/${endParts[1]}';
            }
          }
        }
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: InkWell(
            onTap: () async {
              final DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                final start = picked.start.toIso8601String().split('T')[0];
                final end = picked.end.toIso8601String().split('T')[0];
                _updateFilter('timestamp_between', '$start,$end');
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: hasDateFilter ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.withValues(alpha: .5)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 16,
                    color: hasDateFilter ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    label,
                    style: TextStyle(
                      color: hasDateFilter ? Colors.white : Colors.black,
                    ),
                  ),
                  if (hasDateFilter) ...[
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => _updateFilter('timestamp_between', null),
                      child: const Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterButton({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
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
                  ((state == null || !state.containsKey('action')) && label == 'Tất cả');
              return Container(
                constraints: const BoxConstraints(minWidth: 60),
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.withValues(alpha: .5)),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              );
            },
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
