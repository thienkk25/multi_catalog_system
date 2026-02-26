import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/category_group/presentation/presentation.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_lookup_event.dart';

class CategoryGroupPage extends StatefulWidget {
  const CategoryGroupPage({super.key});

  @override
  State<CategoryGroupPage> createState() => _CategoryGroupPageState();
}

class _CategoryGroupPageState extends State<CategoryGroupPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ValueNotifier<bool> _showUpButton;
  Timer? _debounce;
  late final AnimationController _refreshController;
  late final CategoryGroupBloc _bloc;

  @override
  void initState() {
    super.initState();
    _showUpButton = ValueNotifier(false);
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _bloc = context.groupBloc;
    _bloc.add(const CategoryGroupEvent.getAll(sortBy: 'code', sort: 'asc'));
    _scrollController.addListener(_onScroll);

    context.domainLookupBloc.add(const DomainLookupEvent.lookup());
  }

  void _onRefresh() {
    _bloc.add(
      CategoryGroupEvent.getAll(
        search: _bloc.state.search,
        sortBy: _bloc.state.sortBy,
        sort: _bloc.state.sort,
        filter: _bloc.state.filter,
      ),
    );
    context.domainLookupBloc.add(const DomainLookupEvent.lookup());
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
      _bloc.add(const CategoryGroupEvent.loadMore());
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
                          'Nhóm danh mục',
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
              BlocConsumer<CategoryGroupBloc, CategoryGroupState>(
                listener: (context, state) {
                  if (state.successMessage != null) {
                    context.notificationCubit.success(state.successMessage!);
                  }
                  if (state.error != null) {
                    context.notificationCubit.error(state.error!);
                  }
                },
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
                          _bloc.add(const CategoryGroupEvent.getAll());
                        },
                      ),
                    );
                  }
                  final entries = state.entries;
                  if (entries.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text('Không có dữ liệu')),
                    );
                  }
                  if (ScreenSize.of(context).isMobile ||
                      ScreenSize.of(context).isTablet) {
                    return SliverList.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CategoryGroupCard(entry: entry),
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
                                    child: CategoryGroupCard(entry: entry),
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
              BlocBuilder<CategoryGroupBloc, CategoryGroupState>(
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
          CustomFloatingActionButton(
            onPressedImport: () {
              context.goNamed(RouterNames.importFile, extra: 2);
            },
            onPressedAdd: () {
              context.goNamed(
                RouterNames.categoryGroupForm,
                queryParameters: {'mode': 'create'},
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilterSection(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        Expanded(
          child: CustomInput(
            hintText: 'Tìm kiếm theo mã, tên...',
            suffixIcon: Icon(Icons.search),
            controller: _searchController,
            onChanged: (value) {
              final search = value.trim();
              if (_debounce?.isActive ?? false) {
                _debounce?.cancel();
              }
              _debounce = Timer(const Duration(milliseconds: 500), () {
                if (search.isEmpty) {
                  _bloc.add(const CategoryGroupEvent.getAll());
                } else {
                  _bloc.add(
                    CategoryGroupEvent.getAll(
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
        ),
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => CategoryGroupFilterWidget(),
            );
          },
        ),
      ],
    );
  }
}
