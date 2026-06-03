import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/responsive/screen_size.dart';
import 'package:multi_catalog_system/core/widgets/buttom_up_widget.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_event.dart';
import 'package:multi_catalog_system/features/aprove/presentation/widgets/approve_card.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_state.dart';
import 'package:multi_catalog_system/features/aprove/presentation/widgets/approve_filter_widget.dart';

class ApprovePage extends StatefulWidget {
  const ApprovePage({super.key});

  @override
  State<ApprovePage> createState() => _ApprovePageState();
}

class _ApprovePageState extends State<ApprovePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final TabController _tabController;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late final AnimationController _refreshController;

  late final CategoryItemVersionBloc _bloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _refreshController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _bloc = context.itemVersionBloc;
    _bloc.add(const CategoryItemVersionEvent.getAll());
  }

  void _onRefresh() {
    _bloc.add(const CategoryItemVersionEvent.getAll());
    _refreshController.forward(from: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _refreshController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _showFilter(BuildContext context) {
    final domainLookupBloc = context.domainLookupBloc;
    final groupLookupBloc = context.categoryGroupLookupBloc;
    final itemVersionBloc = context.itemVersionBloc;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: domainLookupBloc),
            BlocProvider.value(value: groupLookupBloc),
            BlocProvider.value(value: itemVersionBloc),
          ],
          child: DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: ApproveFilterWidget(
                  onClose: () => Navigator.pop(context),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mainContent = BlocListener<CategoryItemVersionBloc, CategoryItemVersionState>(
      listener: (context, state) {
        if (state.error != null) {
          context.notificationCubit.error(state.error!);
        }
        if (state.successMessage != null) {
          context.notificationCubit.success(state.successMessage!);
        }
      },
      child: Column(
        children: [
          // --- Header ---
          if (!ScreenSize.of(context).isMobile)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Danh sách duyệt danh mục',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showFilter(context),
                        child: Row(
                          children: [
                            Icon(
                              Icons.filter_alt_outlined,
                              color: Colors.black,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Lọc',
                              style: TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: _onRefresh,
                        child: Row(
                          children: [
                            RotationTransition(
                              turns: _refreshController,
                              child: Icon(
                                Icons.refresh,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Làm mới',
                              style: TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // --- TabBar ---
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            dividerColor: Colors.grey,
            indicatorColor: Colors.blue,
            indicatorWeight: 5,
            splashBorderRadius: BorderRadius.circular(10),
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: "Chờ duyệt"),
              Tab(text: "Đã duyệt"),
              Tab(text: "Từ chối"),
            ],
          ),

          // --- Search ---
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: _buildSearchSection(context),
          ),

          // --- Tab content ---
          Expanded(
            child:
                BlocBuilder<CategoryItemVersionBloc, CategoryItemVersionState>(
                  buildWhen: (previous, current) =>
                      previous.entries != current.entries ||
                      previous.isLoading != current.isLoading,
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final versions = state.entries;

                    // Pre-filter once, not per-tab-build
                    final pending = versions
                        .where((e) => e.status == 'pending')
                        .toList(growable: false);
                    final approved = versions
                        .where((e) => e.status == 'approved')
                        .toList(growable: false);
                    final rejected = versions
                        .where((e) => e.status == 'rejected')
                        .toList(growable: false);

                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _ApproveTabContent(
                          key: const PageStorageKey('pending'),
                          data: pending,
                          bloc: _bloc,
                        ),
                        _ApproveTabContent(
                          key: const PageStorageKey('approved'),
                          data: approved,
                          bloc: _bloc,
                        ),
                        _ApproveTabContent(
                          key: const PageStorageKey('rejected'),
                          data: rejected,
                          bloc: _bloc,
                        ),
                      ],
                    );
                  },
                ),
          ),

          // --- Load more indicator ---
          BlocBuilder<CategoryItemVersionBloc, CategoryItemVersionState>(
            buildWhen: (p, c) => p.isLoadingMore != c.isLoadingMore,
            builder: (context, state) {
              if (!state.isLoadingMore) return const SizedBox.shrink();
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CustomCircularProgressLoadMore()),
              );
            },
          ),
        ],
      ),
    );

    if (ScreenSize.of(context).isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Duyệt danh mục'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              onPressed: () => _showFilter(context),
            ),
            IconButton(
              icon: RotationTransition(
                turns: _refreshController,
                child: const Icon(Icons.refresh),
              ),
              onPressed: _onRefresh,
            ),
          ],
        ),
        body: mainContent,
      );
    }
    return mainContent;
  }

  Widget _buildSearchSection(BuildContext context) {
    return CustomInput(
      controller: _searchController,
      hintText: 'Tìm kiếm theo mã, tên...',
      suffixIcon: const Icon(Icons.search),
      onChanged: (value) {
        final search = value.trim();
        if (_debounce?.isActive ?? false) {
          _debounce?.cancel();
        }
        _debounce = Timer(const Duration(milliseconds: 500), () {
          if (search.isEmpty) {
            _bloc.add(
              CategoryItemVersionEvent.getAll(
                sortBy: _bloc.state.sortBy,
                sort: _bloc.state.sort,
                filter: _bloc.state.filter,
              ),
            );
          } else {
            _bloc.add(
              CategoryItemVersionEvent.getAll(
                search: search,
                sortBy: _bloc.state.sortBy,
                sort: _bloc.state.sort,
                filter: _bloc.state.filter,
              ),
            );
          }
        });
      },
    );
  }
}

/// Separate stateful widget for each tab so each has its own ScrollController
/// and uses AutomaticKeepAliveClientMixin to stay alive when switching tabs.
class _ApproveTabContent extends StatefulWidget {
  final List<CategoryItemVersionEntry> data;
  final CategoryItemVersionBloc bloc;

  const _ApproveTabContent({super.key, required this.data, required this.bloc});

  @override
  State<_ApproveTabContent> createState() => _ApproveTabContentState();
}

class _ApproveTabContentState extends State<_ApproveTabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();
  late ValueNotifier<bool> _showUpButton;

  @override
  void initState() {
    super.initState();
    _showUpButton = ValueNotifier(false);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final shouldShow = _scrollController.offset > 300;
    if (_showUpButton.value != shouldShow) {
      _showUpButton.value = shouldShow;
    }

    if (!widget.bloc.state.hasMore) return;
    if (widget.bloc.state.isLoadingMore) return;

    final position = _scrollController.position;
    // Nội dung phải thực sự scrollable (dài hơn viewport)
    if (position.maxScrollExtent <= 0) return;
    // User phải đã scroll ít nhất 100px để tránh false positive
    if (position.pixels < 100) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      widget.bloc.add(const CategoryItemVersionEvent.loadMore());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _showUpButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.data.isEmpty) {
      return const Center(child: Text("Không có dữ liệu"));
    }

    final isMobile = ScreenSize.of(context).isMobile;
    final isTablet = ScreenSize.of(context).isTablet;

    return Stack(
      children: [
        if (isMobile || isTablet)
          ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(10),
            itemCount: widget.data.length,
            // addAutomaticKeepAlives so cards near viewport edge aren't
            // destroyed and rebuilt every swipe
            addAutomaticKeepAlives: true,
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ApproveCard(version: widget.data[i]),
              );
            },
          )
        else
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount =
                    (constraints.maxWidth / 600).floor().clamp(1, 6);
                final itemWidth =
                    constraints.maxWidth / crossAxisCount - 10;

                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: widget.data.map(
                    (entry) => SizedBox(
                      width: itemWidth,
                      child: ApproveCard(version: entry),
                    ),
                  ).toList(),
                );
              },
            ),
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
}
