import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/config/app/url_strategy.dart'
    if (dart.library.html) 'package:multi_catalog_system/core/config/app/url_strategy_web.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/home/presentation/widgets/drawer_widget.dart';

import 'features/features.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     scaffoldBackgroundColor: Colors.white,
    //     appBarTheme: AppBarTheme(
    //       backgroundColor: Colors.blue,
    //       foregroundColor: Colors.white,
    //     ),
    //   ),
    //   home: Scaffold(
    //     appBar: AppBar(title: const Text('Multi Catalog System')),
    //     drawer: DrawerWidget(),
    //     body: SafeArea(child: CategoryGroupPage()),
    //   ),
    // );
  }
}
