import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/config/app/url_strategy.dart'
    if (dart.library.html) 'package:multi_catalog_system/core/config/app/url_strategy_web.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/home/presentation/widgets/drawer_widget.dart';

import 'features/features.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy();
  await init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>(),
      child: MaterialApp.router(
        title: '',
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFF5F7FA),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF5F7FA),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Multi Catalog System')),
        drawer: DrawerWidget(),
        body: SafeArea(child: LegalDocumentPage()),
      ),
    );
  }
}
