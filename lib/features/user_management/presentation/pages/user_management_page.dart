import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_bloc.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_event.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_state.dart';
import 'package:multi_catalog_system/features/user_management/presentation/widgets/user_management_card.dart';
import 'package:multi_catalog_system/features/user_management/presentation/widgets/user_management_filter_widget.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollFilterController = ScrollController();
  Timer? _debounce;
  late final UserManagementBloc bloc;
  late ValueNotifier<bool> _showUpButton;
  bool isFilterOpen = false;
  final double filterWidth = 300;

  @override
  void initState() {
    super.initState();
    _showUpButton = ValueNotifier(false);
    bloc = context.userManagementBloc;
    bloc.add(const UserManagementEvent.getAll());
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
      bloc.add(const UserManagementEvent.loadMore());
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
    return SingleChildScrollView(
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
                          child: const Text(
                            'Quản lý người dùng',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverToBoxAdapter(
                        child: _buildSearchFilterSection(context),
                      ),
                    ),
                    BlocConsumer<UserManagementBloc, UserManagementState>(
                      listener: (context, state) {
                        if (state.successMessage != null) {
                          context.notificationCubit.success(
                            state.successMessage!,
                          );
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
                            child: Center(
                              child: CustomCircularProgressScreen(),
                            ),
                          );
                        }

                        if (state.error != null) {
                          return SliverFillRemaining(
                            child: ErrorRetryWidget(
                              error: state.error!,
                              onRetry: () {
                                bloc.add(const UserManagementEvent.getAll());
                              },
                            ),
                          );
                        }

                        if (state.entries.isEmpty) {
                          return SliverFillRemaining(
                            child: const Center(
                              child: Text('Không có dữ liệu'),
                            ),
                          );
                        }

                        final entries = state.entries;
                        if (ScreenSize.of(context).isMobile ||
                            ScreenSize.of(context).isTablet) {
                          return SliverList.builder(
                            itemBuilder: (context, index) {
                              final entry = entries[index];
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: UserManagementCard(entry: entry),
                              );
                            },
                            itemCount: entries.length,
                          );
                        }
                        return SliverToBoxAdapter(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final crossAxisCount =
                                  (constraints.maxWidth / 600).floor().clamp(
                                    1,
                                    6,
                                  );

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
                                          child: UserManagementCard(
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
                        );
                      },
                    ),
                    BlocBuilder<UserManagementBloc, UserManagementState>(
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
                  onPressedImport: () {},
                  onPressedAdd: () {
                    context.goNamed(
                      RouterNames.userManagementForm,
                      queryParameters: {'mode': 'create'},
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: filterWidth,
            child: UserManagementFilterWidget(onClose: _closeFilter),
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
            hintText: 'Tìm kiếm...',
            suffixIcon: const Icon(Icons.search),
            onChanged: (value) {
              final search = value.trim();
              if (_debounce?.isActive ?? false) {
                _debounce?.cancel();
              }
              _debounce = Timer(const Duration(milliseconds: 500), () {
                if (search.isEmpty) {
                  bloc.add(const UserManagementEvent.getAll());
                } else {
                  bloc.add(UserManagementEvent.getAll(search: search));
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
