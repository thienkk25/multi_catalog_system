import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/bloc/api_key_bloc.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/bloc/api_key_event.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/bloc/api_key_state.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/widgets/api_key_management_card.dart';

class ApiKeyManagementPage extends StatefulWidget {
  const ApiKeyManagementPage({super.key});

  @override
  State<ApiKeyManagementPage> createState() => _ApiKeyManagementPageState();
}

class _ApiKeyManagementPageState extends State<ApiKeyManagementPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  late ValueNotifier<bool> _showUpButton;
  late final AnimationController _refreshController;
  late final ApiKeyBloc _bloc;

  @override
  void initState() {
    super.initState();
    _showUpButton = ValueNotifier(false);
    _refreshController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _bloc = context.apiKeyBloc;
    _bloc.add(ApiKeyEvent.getAll(sortBy: 'system_name', sort: 'asc'));

    _scrollController.addListener(_onScroll);
  }

  void _onRefresh() {
    _bloc.add(
      ApiKeyEvent.getAll(
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
      _bloc.add(const ApiKeyEvent.loadMore());
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
                          'Quản lý API Key',
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
              BlocConsumer<ApiKeyBloc, ApiKeyState>(
                listener: (context, state) {
                  if (state.createdEntry != null) {
                    _showSuccessDialog(context, state.createdEntry!.key!);
                  }
                  if (state.successMessage != null) {
                    context.notificationCubit.success(state.successMessage!);
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
                            ApiKeyEvent.getAll(
                              search: state.search,
                              page: state.page,
                              sortBy: state.sortBy,
                              sort: state.sort,
                              filter: state.filter,
                            ),
                          );
                        },
                      ),
                    );
                  }
                  if (state.entries.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text('Không có dữ liệu')),
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
                          child: ApiKeyManagementCard(entry: entry),
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
                                    child: ApiKeyManagementCard(entry: entry),
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
              BlocBuilder<ApiKeyBloc, ApiKeyState>(
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
            onPressedImport: () {},
            onPressedAdd: () {
              context.goNamed(RouterNames.apiKeyForm);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    context.notificationCubit.success('Sao chép API Key thành công');
  }

  void _showSuccessDialog(BuildContext context, String apiKey) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: .1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 36,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Tạo API Key thành công',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Vui lòng sao chép và lưu trữ API Key.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 16),

                CodeBlockWidget(text: apiKey),

                const SizedBox(height: 20),

                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: CustomButton(
                        colorBackground: Colors.white,
                        textButton: Text('Đóng'),
                        onTap: () => context.pop(),
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        colorBackground: Colors.blue,
                        textButton: const Text(
                          'Sao chép',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () => _copyToClipboard(context, apiKey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchFilterSection(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomInput(
          controller: _searchController,
          hintText: 'Tìm kiếm...',
          suffixIcon: Icon(Icons.search),
          onChanged: (value) {
            final search = value.trim();
            if (_debounce?.isActive ?? false) {
              _debounce?.cancel();
            }
            _debounce = Timer(const Duration(milliseconds: 500), () {
              if (search.isEmpty) {
                _bloc.add(
                  ApiKeyEvent.getAll(sortBy: 'system_name', sort: 'asc'),
                );
              } else {
                _bloc.add(
                  ApiKeyEvent.getAll(
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
                  const ApiKeyEvent.getAll(sortBy: 'system_name', sort: 'asc'),
                ),
              ),
              _buildFilterButton(
                context: context,
                label: 'Hoạt động',
                onTap: () => _bloc.add(
                  ApiKeyEvent.getAll(
                    search: _bloc.state.search,
                    filter: {'status': 'active'},
                    sortBy: _bloc.state.sortBy,
                    sort: _bloc.state.sort,
                  ),
                ),
              ),
              _buildFilterButton(
                context: context,
                label: 'Thu hồi',
                onTap: () => _bloc.add(
                  ApiKeyEvent.getAll(
                    search: _bloc.state.search,
                    filter: {'status': 'revoked'},
                    sortBy: _bloc.state.sortBy,
                    sort: _bloc.state.sort,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: 200,
                child: CustomDropdownButton<String>(
                  value: 'system_name|asc',
                  items: const [
                    DropdownMenuItem(
                      value: 'system_name|asc',
                      child: Text('Tên (A → Z)'),
                    ),
                    DropdownMenuItem(
                      value: 'system_name|desc',
                      child: Text('Tên (Z → A)'),
                    ),
                    DropdownMenuItem(
                      value: 'status|asc',
                      child: Text('Trạng thái (A → Z)'),
                    ),
                    DropdownMenuItem(
                      value: 'status|desc',
                      child: Text('Trạng thái (Z → A)'),
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
                      ApiKeyEvent.getAll(
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
      child: BlocSelector<ApiKeyBloc, ApiKeyState, Map<String, dynamic>?>(
        selector: (state) => state.filter,
        builder: (context, state) {
          final isSelected =
              (state != null && state['status'] == _actionText(label)) ||
              (state == null && label == 'Tất cả');
          return Container(
            constraints: const BoxConstraints(minWidth: 60),
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.withValues(alpha: .5)),
            ),
            child: Text(
              label,
              style: TextStyle(color: isSelected ? Colors.white : Colors.black),
            ),
          );
        },
      ),
    );
  }

  String _actionText(String action) {
    switch (action) {
      case 'Hoạt động':
        return 'active';
      case 'Thu hồi':
        return 'revoked';
      default:
        return '-';
    }
  }
}
