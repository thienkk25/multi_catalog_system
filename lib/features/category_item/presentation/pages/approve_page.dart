import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/responsive/screen_size.dart';
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
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final TabController _tabController;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.itemVersionBloc.add(const CategoryItemVersionEvent.getAll());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final bloc = context.itemVersionBloc;
    if (!_scrollController.hasClients) return;
    if (!bloc.state.hasMore) return;
    if (bloc.state.isLoadingMore) return;

    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      bloc.add(const CategoryItemVersionEvent.loadMore());
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
    return BlocListener<CategoryItemVersionBloc, CategoryItemVersionState>(
      listener: (context, state) {
        if (state.error != null) {
          context.notificationCubit.error(state.error!);
        }
        if (state.successMessage != null) {
          context.notificationCubit.success(state.successMessage!);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            dividerColor: Colors.grey,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: 'Chờ duyệt'),
              Tab(text: 'Đã duyệt'),
              Tab(text: 'Từ chối'),
            ],
          ),
        ),
        body: BlocBuilder<CategoryItemVersionBloc, CategoryItemVersionState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final versions = state.entries;

            return SafeArea(
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
      ),
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
        itemCount:
            data.length + (context.itemVersionBloc.state.isLoadingMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i >= data.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CustomCircularProgressLoadMore()),
            );
          }
          final version = data[i];
          return _buildGovApproveCard(version);
        },
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth / 600).floor().clamp(1, 6);

        final itemWidth = constraints.maxWidth / crossAxisCount - 10;

        return SingleChildScrollView(
          controller: _scrollController,
          child: Column(
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

              if (context.itemVersionBloc.state.isLoadingMore)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CustomCircularProgressLoadMore(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGovApproveCard(CategoryItemVersionEntry version) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ApproveCard(version: version),
    );
  }
}
