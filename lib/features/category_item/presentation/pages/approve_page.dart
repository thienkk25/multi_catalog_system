import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/responsive/screen_size.dart';
import 'package:multi_catalog_system/core/widgets/buttom_up_widget.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_event.dart';
import 'package:multi_catalog_system/features/category_item/presentation/widgets/approve_card.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_state.dart';

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

  final ScrollController _scrollController = ScrollController();
  late final AnimationController _refreshController;
  late ValueNotifier<bool> _showUpButton;

  late final CategoryItemVersionBloc _bloc;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _refreshController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _showUpButton = ValueNotifier(false);
    _bloc = context.itemVersionBloc;
    _bloc.add(const CategoryItemVersionEvent.getAll());
    _scrollController.addListener(_onScroll);
  }

  void _onRefresh() {
    _bloc.add(const CategoryItemVersionEvent.getAll());
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
      _bloc.add(const CategoryItemVersionEvent.loadMore());
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Row(
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
                        Text(
                          'Làm mới',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              bottom: TabBar(
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
            ),
            BlocConsumer<CategoryItemVersionBloc, CategoryItemVersionState>(
              listener: (context, state) {
                if (state.error != null) {
                  context.notificationCubit.error(state.error!);
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
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                final versions = state.entries;

                return SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTab("pending", versions),
                        _buildTab("approved", versions),
                        _buildTab("rejected", versions),
                      ],
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<CategoryItemVersionBloc, CategoryItemVersionState>(
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

  Widget _buildTab(String status, List<CategoryItemVersionEntry> versions) {
    final data = versions.where((e) => e.status == status).toList();
    if (data.isEmpty) {
      return const Center(child: Text("Không có dữ liệu"));
    }

    final isMobile = ScreenSize.of(context).isMobile;
    final isTablet = ScreenSize.of(context).isTablet;

    if (isMobile || isTablet) {
      return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (_, i) {
          final version = data[i];
          return _buildGovApproveCard(version);
        },
      );
    }
    return SingleChildScrollView(
      controller: _scrollController,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = (constraints.maxWidth / 600).floor().clamp(
            1,
            6,
          );

          final itemWidth = constraints.maxWidth / crossAxisCount - 10;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ...data.map(
                    (entry) => SizedBox(
                      width: itemWidth,
                      child: _buildGovApproveCard(entry),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGovApproveCard(CategoryItemVersionEntry version) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ApproveCard(version: version),
    );
  }
}
