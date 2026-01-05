import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/features.dart';

class HomePageConfig {
  final Widget Function() builder;
  const HomePageConfig({required this.builder});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<HomePageConfig> _configs;
  late final List<Widget?> _pages;

  @override
  void initState() {
    super.initState();
    _configs = [
      HomePageConfig(builder: () => const CategoryLookupPage()),
      HomePageConfig(
        builder: () => BlocProvider(
          create: (_) => getIt<DomainManagementBloc>(),
          child: const DomainManagementPage(),
        ),
      ),
      HomePageConfig(
        builder: () => BlocProvider(
          create: (_) => getIt<CategoryGroupBloc>(),
          child: const CategoryGroupPage(),
        ),
      ),
      HomePageConfig(
        builder: () => BlocProvider(
          create: (_) => getIt<CategoryItemBloc>(),
          child: const CategoryItemPage(),
        ),
      ),
      HomePageConfig(builder: () => const LegalDocumentPage()),
      HomePageConfig(
        builder: () =>
            RoleBasedWidget(permission: ['approver'], child: ApproverPage()),
      ),
      HomePageConfig(
        builder: () =>
            RoleBasedWidget(permission: ['admin'], child: UserManagementPage()),
      ),
      HomePageConfig(
        builder: () => RoleBasedWidget(
          permission: ['admin'],
          child: BlocProvider(
            create: (_) => getIt<ApiKeyBloc>(),
            child: ApiKeyManagementPage(),
          ),
        ),
      ),
    ];
    _pages = List.filled(_configs.length, null);
  }

  Widget _getPage(int index) {
    return _pages[index] ??= _configs[index].builder();
  }

  void _clearCache() {
    for (var i = 0; i < _pages.length; i++) {
      _pages[i] = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.mapOrNull(unauthenticated: (_) => _clearCache());
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final index = state.mapOrNull(page: (p) => p.index) ?? 0;

          _getPage(index);

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: state.mapOrNull(
                page: (p) => Text(
                  p.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            drawer: const DrawerWidget(),
            body: SafeArea(
              child: IndexedStack(
                index: index,
                children: List.generate(
                  _pages.length,
                  (i) => _pages[i] ?? const SizedBox.shrink(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
