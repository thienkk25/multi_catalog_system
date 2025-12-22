import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/features.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<Widget?> _pages;

  @override
  void initState() {
    super.initState();
    _pages = List.filled(5, null);
  }

  Widget _buildPage(int index) {
    if (_pages[index] != null) return _pages[index]!;

    late final Widget page;

    switch (index) {
      case 0:
        page = const CategoryLookupPage();
        break;
      case 1:
        page = BlocProvider(
          create: (_) => getIt<DomainManagementBloc>(),
          child: const DomainManagementPage(),
        );
        break;
      case 2:
        page = const CategoryGroupPage();
        break;
      case 3:
        page = const CategoryItemPage();
        break;
      case 4:
        page = const LegalDocumentPage();
        break;
      default:
        page = const NotFoundPage();
    }

    _pages[index] = page;
    return page;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final index = state.mapOrNull(page: (p) => p.index) ?? 0;

        return Scaffold(
          appBar: AppBar(
            title: state.mapOrNull(
              page: (p) => Text(
                p.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            centerTitle: true,
          ),
          drawer: const DrawerWidget(),
          body: SafeArea(
            child: Stack(
              children: List.generate(
                _pages.length,
                (i) => Offstage(offstage: i != index, child: _buildPage(i)),
              ),
            ),
          ),
        );
      },
    );
  }
}
