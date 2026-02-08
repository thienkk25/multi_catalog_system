import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/features/approve/presentation/widgets/approve_card.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_state.dart';

class ApprovePage extends StatefulWidget {
  const ApprovePage({super.key});

  @override
  State<ApprovePage> createState() => _ApprovePageState();
}

class _ApprovePageState extends State<ApprovePage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duyệt danh mục'),
        centerTitle: true,
        bottom: TabBar(
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
    );
  }

  Widget _buildTab(String status, List<CategoryItemVersionEntry> versions) {
    final data = versions.where((e) => e.status == status).toList();

    if (data.isEmpty) {
      return const Center(child: Text("Không có dữ liệu"));
    }

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (_, i) {
        final version = data[i];
        return _buildGovApproveCard(version);
      },
    );
  }

  Widget _buildGovApproveCard(CategoryItemVersionEntry version) {
    return ApproveCard(version: version);
  }
}
