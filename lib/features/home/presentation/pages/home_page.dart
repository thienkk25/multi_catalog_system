import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/responsive/responsive_builder.dart';
import 'package:multi_catalog_system/features/home/presentation/widgets/home_drawer_widget.dart';

class HomePage extends StatelessWidget {
  final int currentIndex;
  final Function(int index) onSelectTab;
  final Widget? body;
  const HomePage({
    super.key,
    required this.onSelectTab,
    this.body,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screen) {
        if (screen.isMobile) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Hệ thống quản lý danh mục'),
            ),
            drawer: HomeDrawerWidget(
              currentIndex: currentIndex,
              onSelectTab: onSelectTab,
            ),
            body: body,
          );
        }

        return Row(
          children: [
            HomeDrawerWidget(
              currentIndex: currentIndex,
              onSelectTab: onSelectTab,
            ),
            Expanded(
              child: Scaffold(
                body: Column(
                  children: [
                    const SizedBox(height: 10),
                    Expanded(child: body ?? Container()),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
