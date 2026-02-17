import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/features/home/presentation/pages/home_page.dart';

class HomeShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeShell({super.key, required this.navigationShell});

  void _goTab(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomePage(
      currentIndex: navigationShell.currentIndex,
      body: navigationShell,
      onSelectTab: _goTab,
    );
  }
}
