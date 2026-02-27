import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/responsive/screen_size.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/buttom_up_widget.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/custom_floating_action_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/error_retry_widget.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_event.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_state.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_state.dart';
import 'package:multi_catalog_system/features/category_item/presentation/pages/category_item_form_page.dart';
import 'package:multi_catalog_system/features/category_item/presentation/widgets/category_item_card.dart';
import 'package:multi_catalog_system/features/category_item/presentation/widgets/category_item_filter_widget.dart';

class CategoryItemPage extends StatefulWidget {
  const CategoryItemPage({super.key});

  @override
  State<CategoryItemPage> createState() => _CategoryItemPageState();
}

class _CategoryItemPageState extends State<CategoryItemPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollFilterController = ScrollController();
  late final AnimationController _refreshController;
  late ValueNotifier<bool> _showUpButton;
  Timer? _debounce;

  late CategoryItemBloc _bloc;
  bool isFilterOpen = false;
  final double filterWidth = 300;

  @override
  void initState() {
    super.initState();
    _showUpButton = ValueNotifier(false);
    _refreshController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _bloc = context.itemBloc;
    context.itemBloc.add(const CategoryItemEvent.getAll());
    _scrollController.addListener(_onScroll);
  }

  void _onRefresh() {
    _bloc.add(const CategoryItemEvent.getAll());
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
      _bloc.add(const CategoryItemEvent.loadMore());
    }
  }

  void _toggleFilter() {
    isFilterOpen = !isFilterOpen;
    if (isFilterOpen) {
      _openFilter();
    } else {
      _closeFilter();
    }
  }

  void _openFilter() {
    _scrollFilterController.animateTo(
      filterWidth,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _closeFilter() {
    _scrollFilterController.animateTo(
      0,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _scrollFilterController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenSize = ScreenSize.of(context);
    final screenWidth = screenSize.width - (screenSize.isMobile ? 0 : 250);
    return MultiBlocListener(
      listeners: [
        BlocListener<CategoryItemBloc, CategoryItemState>(
          listener: (context, state) {
            if (state.error != null) {
              context.notificationCubit.error(state.error!);
            }
            if (state.successMessage != null) {
              context.notificationCubit.success(state.successMessage!);
            }
          },
        ),
        BlocListener<CategoryItemVersionBloc, CategoryItemVersionState>(
          listener: (context, state) {
            if (state.error != null) {
              context.notificationCubit.error(state.error!);
            }
            if (state.successMessage != null) {
              context.notificationCubit.success(state.successMessage!);
            }
          },
        ),
      ],
      child: SingleChildScrollView(
        controller: _scrollFilterController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            SizedBox(
              width: screenWidth,
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
                                  'Mục danh mục',
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
                      BlocBuilder<CategoryItemBloc, CategoryItemState>(
                        buildWhen: (prev, curr) =>
                            prev.entries != curr.entries ||
                            prev.isLoading != curr.isLoading,
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(
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
                                  _bloc.add(const CategoryItemEvent.getAll());
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
                            return SliverPadding(
                              padding: const EdgeInsets.all(16),
                              sliver: SliverList.builder(
                                itemCount: entries.length,
                                itemBuilder: (context, index) {
                                  final entry = entries[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: CategoryItemCard(entry: entry),
                                  );
                                },
                              ),
                            );
                          }
                          return SliverPadding(
                            padding: const EdgeInsets.all(16),
                            sliver: SliverToBoxAdapter(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final crossAxisCount =
                                      (constraints.maxWidth / 600)
                                          .floor()
                                          .clamp(1, 6);

                                  final itemWidth =
                                      constraints.maxWidth / crossAxisCount -
                                      10;

                                  return Column(
                                    children: [
                                      Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: [
                                          ...entries.map(
                                            (entry) => SizedBox(
                                              width: itemWidth,
                                              child: CategoryItemCard(
                                                entry: entry,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      BlocBuilder<CategoryItemBloc, CategoryItemState>(
                        buildWhen: (p, c) => p.isLoadingMore != c.isLoadingMore,
                        builder: (context, state) {
                          if (!state.isLoadingMore) {
                            return const SliverToBoxAdapter(
                              child: SizedBox.shrink(),
                            );
                          }

                          return const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: CustomCircularProgressLoadMore(),
                              ),
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
                      context.goNamed(RouterNames.importFile, extra: 3);
                    },
                    onPressedAdd: () {
                      context.goNamed(
                        RouterNames.categoryItemForm,
                        queryParameters: {
                          'mode': CategoryItemFormMode.create.name,
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: filterWidth,
              child: CategoryItemFilterWidget(onClose: _closeFilter),
            ),
          ],
        ),
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
            suffixIcon: const Icon(Icons.search),
            onChanged: (value) {
              final search = value.trim();
              if (_debounce?.isActive ?? false) {
                _debounce?.cancel();
              }
              _debounce = Timer(const Duration(milliseconds: 500), () {
                if (search.isEmpty) {
                  _bloc.add(
                    const CategoryItemEvent.getAll(sortBy: 'code', sort: 'asc'),
                  );
                } else {
                  _bloc.add(
                    CategoryItemEvent.getAll(
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
          icon: Icon(Icons.filter_list_alt),
          onPressed: () => _toggleFilter(),
        ),
      ],
    );
  }
}
