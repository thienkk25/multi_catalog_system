import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/presentation.dart';

class LegalDocumentPage extends StatefulWidget {
  const LegalDocumentPage({super.key});

  @override
  State<LegalDocumentPage> createState() => _LegalDocumentPageState();
}

class _LegalDocumentPageState extends State<LegalDocumentPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  late ValueNotifier<bool> _showUpButton;
  late final AnimationController _refreshController;
  late final LegalDocumentBloc _bloc;

  @override
  void initState() {
    super.initState();
    _showUpButton = ValueNotifier(false);
    _refreshController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _bloc = context.legalDocumentBloc;
    _bloc.add(LegalDocumentEvent.getAll(sortBy: 'name', sort: 'asc'));
    _scrollController.addListener(_onScroll);
  }

  void _onRefresh() {
    _bloc.add(
      LegalDocumentEvent.getAll(
        search: _bloc.state.search,
        sortBy: _bloc.state.sortBy,
        sort: _bloc.state.sort,
        filter: _bloc.state.filter,
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
      _bloc.add(const LegalDocumentEvent.loadMore());
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
                          'Văn bản pháp lý',
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
              BlocConsumer<LegalDocumentBloc, LegalDocumentState>(
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
                          _bloc.add(
                            LegalDocumentEvent.getAll(
                              search: state.search,
                              sortBy: state.sortBy,
                              sort: state.sort,
                              filter: state.filter,
                            ),
                          );
                        },
                      ),
                    );
                  }

                  final entries = state.entries;
                  if (entries.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: const Center(child: Text('Không có văn bản nào')),
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
                          child: LegalDocumentCard(entry: entry),
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
                                    child: LegalDocumentCard(entry: entry),
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
              BlocBuilder<LegalDocumentBloc, LegalDocumentState>(
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
            permission: ['admin'],
            onPressedImport: () {},
            onPressedAdd: () {
              context.goNamed(
                RouterNames.legalDocumentForm,
                queryParameters: {'mode': 'create'},
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
          hintText: 'Tìm kiếm văn bản...',
          suffixIcon: Icon(Icons.search),
          onChanged: (value) {
            final search = value.trim();
            if (_debounce?.isActive ?? false) {
              _debounce?.cancel();
            }
            _debounce = Timer(const Duration(milliseconds: 500), () {
              if (search.isEmpty) {
                _bloc.add(
                  LegalDocumentEvent.getAll(
                    sortBy: _bloc.state.sortBy,
                    sort: _bloc.state.sort,
                    filter: _bloc.state.filter,
                  ),
                );
              } else {
                _bloc.add(
                  LegalDocumentEvent.getAll(
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
                onTap: () => _bloc.add(
                  LegalDocumentEvent.getAll(sortBy: 'name', sort: 'asc'),
                ),
              ),
              _buildFilterButton(
                context: context,
                label: 'Luật',
                onTap: () => _bloc.add(
                  LegalDocumentEvent.getAll(
                    filter: {'type': 'Luật'},
                    sortBy: _bloc.state.sortBy,
                    sort: _bloc.state.sort,
                  ),
                ),
              ),
              _buildFilterButton(
                context: context,
                label: 'Nghị định',
                onTap: () => _bloc.add(
                  LegalDocumentEvent.getAll(
                    filter: {'type': 'Nghị định'},
                    sortBy: _bloc.state.sortBy,
                    sort: _bloc.state.sort,
                  ),
                ),
              ),
              _buildFilterButton(
                context: context,
                label: 'Thông tư',
                onTap: () => _bloc.add(
                  LegalDocumentEvent.getAll(
                    filter: {'type': 'Thông tư'},
                    sortBy: _bloc.state.sortBy,
                    sort: _bloc.state.sort,
                  ),
                ),
              ),
              _buildFilterButton(
                context: context,
                label: 'Khác',
                onTap: () => _bloc.add(
                  LegalDocumentEvent.getAll(
                    filter: {'type': 'Khác'},
                    sortBy: _bloc.state.sortBy,
                    sort: _bloc.state.sort,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: 200,
                child: CustomDropdownButton<String>(
                  value: 'name|asc',
                  items: const [
                    DropdownMenuItem(
                      value: 'name|asc',
                      child: Text('Tên (A → Z)'),
                    ),
                    DropdownMenuItem(
                      value: 'name|desc',
                      child: Text('Tên (Z → A)'),
                    ),
                    DropdownMenuItem(
                      value: 'code|asc',
                      child: Text('Mã (A → Z)'),
                    ),
                    DropdownMenuItem(
                      value: 'code|desc',
                      child: Text('Mã (Z → A)'),
                    ),
                    DropdownMenuItem(
                      value: 'created_at|desc',
                      child: Text('Mới nhất'),
                    ),
                    DropdownMenuItem(
                      value: 'created_at|asc',
                      child: Text('Cũ nhất'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;

                    final parts = value.split('|');
                    _bloc.add(
                      LegalDocumentEvent.getAll(
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

  Widget _buildFilterButton({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child:
          BlocSelector<
            LegalDocumentBloc,
            LegalDocumentState,
            Map<String, dynamic>?
          >(
            selector: (state) => state.filter,
            builder: (context, state) {
              final isSelected =
                  (state != null && state['type'] == label) ||
                  (state == null && label == 'Tất cả');
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
}
