import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/features/features.dart';
import 'package:multi_catalog_system/features/home/presentation/bloc/home_state.dart';
import 'package:multi_catalog_system/features/home/presentation/widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final pageIndex = state.mapOrNull(page: (p) => p.index);
        return Scaffold(
          appBar: AppBar(
            title: context.watch<HomeBloc>().state.mapOrNull(
              page: (value) => Text(value.title),
            ),
            centerTitle: true,
          ),
          drawer: DrawerWidget(),
          body: SafeArea(child: _buildPage(pageIndex ?? 0)),
        );
      },
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return CategoryLookupPage();

      case 1:
        return DomainManagementPage();

      case 2:
        return CategoryGroupPage();

      case 3:
        return CategoryItemPage();

      case 4:
        return LegalDocumentPage();

      default:
        return Center(child: Text("Page không tồn tại"));
    }
  }
}
