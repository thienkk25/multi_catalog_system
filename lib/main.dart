import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/config/app/url_strategy.dart'
    if (dart.library.html) 'package:multi_catalog_system/core/config/app/url_strategy_web.dart';
import 'package:multi_catalog_system/core/core.dart';

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
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
