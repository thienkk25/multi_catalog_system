import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/responsive/screen_size.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/buttom_up_widget.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/custom_dropdown_button.dart';
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

class CategoryItemPage extends StatefulWidget {
  const CategoryItemPage({super.key});

  @override
  State<CategoryItemPage> createState() => _CategoryItemPageState();
}

class _CategoryItemPageState extends State<CategoryItemPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ValueNotifier<bool> _showUpButton;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _showUpButton = ValueNotifier(false);
    context.itemBloc.add(const CategoryItemEvent.getAll());

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final bloc = context.itemBloc;
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
      bloc.add(const CategoryItemEvent.loadMore());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      child: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              if (!ScreenSize.of(context).isMobile)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: const Text(
                      'Mục danh mục',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(child: _buildFilterSection(context)),
              ),
              BlocBuilder<CategoryItemBloc, CategoryItemState>(
                buildWhen: (prev, curr) =>
                    prev.entries != curr.entries ||
                    prev.isLoading != curr.isLoading,
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
                      child: ErrorRetryWidget(
                        error: state.error!,
                        onRetry: () {
                          context.itemBloc.add(
                            const CategoryItemEvent.getAll(),
                          );
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
                            padding: const EdgeInsets.all(10.0),
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
                                      child: CategoryItemCard(entry: entry),
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
              context.goNamed(RouterNames.importFile, extra: 3);
            },
            onPressedAdd: () {
              context.goNamed(
                RouterNames.categoryItemForm,
                queryParameters: {'mode': CategoryItemFormMode.create.name},
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomInput(
          hintText: 'Tìm kiếm theo tên, mã...',
          suffixIcon: Icon(Icons.search),
          onChanged: (value) {
            final search = value.trim();
            if (_debounce?.isActive ?? false) {
              _debounce?.cancel();
            }
            _debounce = Timer(const Duration(milliseconds: 500), () {
              if (search.isEmpty) {
                context.itemBloc.add(const CategoryItemEvent.getAll());
              } else {
                context.itemBloc.add(CategoryItemEvent.getAll(search: search));
              }
            });
          },
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text('Sắp xếp theo'),
            SizedBox(
              width: 170,
              child: CustomDropdownButton(
                items: [
                  DropdownMenuItem(value: 'code', child: Text('Mã lĩnh vực')),
                  DropdownMenuItem(value: 'name', child: Text('Tên lĩnh vực')),
                  DropdownMenuItem(
                    value: 'created_at',
                    child: Text('Ngày tạo'),
                  ),
                  DropdownMenuItem(
                    value: 'updated_at',
                    child: Text('Ngày cập nhật'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                },
              ),
            ),
            SizedBox(
              width: 150,
              child: CustomDropdownButton(
                items: [
                  DropdownMenuItem(value: 'asc', child: Text('Tăng dần')),
                  DropdownMenuItem(value: 'desc', child: Text('Giảm dần')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
