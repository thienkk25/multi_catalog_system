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
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ValueNotifier<bool> _showUpButton;
  Timer? _debounce;
  late final CategoryGroupBloc _bloc;
  late Map<String, dynamic> _filter;
  @override
  void initState() {
    super.initState();
    _bloc = context.groupBloc;
    _bloc.add(const CategoryGroupEvent.getAll());
    _showUpButton = ValueNotifier(false);
    _scrollController.addListener(_onScroll);
    _filter = {};

    context.domainLookupBloc.add(const DomainLookupEvent.lookup());
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
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nhóm danh mục',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
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
                        _debounce = Timer(
                          const Duration(milliseconds: 500),
                          () {
                            if (search.isEmpty) {
                              _bloc.add(const CategoryGroupEvent.getAll());
                            } else {
                              _bloc.add(
                                CategoryGroupEvent.getAll(search: search),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => CategoryGroupFilterSearchWidget(
                          search: _searchController.text.trim(),
                          filter: _filter,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: BlocConsumer<CategoryGroupBloc, CategoryGroupState>(
                  listener: (context, state) {
                    if (state.successMessage != null) {
                      context.notificationCubit.success(state.successMessage!);
                    }
                    if (state.error != null) {
                      context.notificationCubit.error(state.error!);
                    }
                  },
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CustomCircularProgressScreen(),
                      );
                    }
                    if (state.error != null) {
                      return ErrorRetryWidget(
                        error: state.error!,
                        onRetry: () {
                          _bloc.add(const CategoryGroupEvent.getAll());
                        },
                      );
                    }
                    final entries = state.entries;
                    if (entries.isEmpty) {
                      return const Center(child: Text('Không có dữ liệu'));
                    }
                    if (ScreenSize.of(context).isMobile ||
                        ScreenSize.of(context).isTablet) {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            entries.length + (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= entries.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: CustomCircularProgressLoadMore(),
                              ),
                            );
                          }
                          final entry = entries[index];
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CategoryGroupCard(entry: entry),
                          );
                        },
                      );
                    }
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = (constraints.maxWidth / 600)
                            .floor()
                            .clamp(1, 6);

                        final itemWidth =
                            constraints.maxWidth / crossAxisCount - 10;

                        return SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
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

                              if (state.isLoadingMore)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: CustomCircularProgressLoadMore(),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
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
    );
  }
}
