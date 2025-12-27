import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/config/app/url_strategy.dart'
    if (dart.library.html) 'package:multi_catalog_system/core/config/app/url_strategy_web.dart';

import 'core/core.dart';
import 'features/auth/presentation/presentation.dart';
import 'features/catalog_lookup/presentation/presentation.dart';
import 'features/home/presentation/presentation.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<HomeBloc>()),
        BlocProvider(
          create: (_) =>
              getIt<CatalogLookupBloc>()
                ..add(const CatalogLookupEvent.getDomainsRef()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<AuthBloc>()..add(const AuthEvent.checkAuthenticated()),
        ),
      ],
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
  }
}
