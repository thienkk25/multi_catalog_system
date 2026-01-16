import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/config/app/url_strategy.dart'
    if (dart.library.html) 'package:multi_catalog_system/core/config/app/url_strategy_web.dart';
import 'core/core.dart';
import 'features/auth/presentation/presentation.dart';
import 'features/catalog_lookup/presentation/presentation.dart';
import 'features/home/presentation/presentation.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

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
      create: (_) =>
          getIt<AuthBloc>()..add(const AuthEvent.checkAuthenticated()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.mapOrNull(
            authenticated: (authState) {
              if (authState.message != null) {
                scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.green,
                    content: Text(authState.message!),
                  ),
                );
              }
            },
            unauthenticated: (unauthState) {
              if (unauthState.message != null) {
                scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.green,
                    content: Text(unauthState.message!),
                  ),
                );
              }
            },
          );
        },
        buildWhen: (previous, current) {
          final prevAuth = previous.mapOrNull(
            authenticated: (_) => true,
            unauthenticated: (_) => false,
          );

          final currAuth = current.mapOrNull(
            authenticated: (_) => true,
            unauthenticated: (_) => false,
          );

          return prevAuth != currAuth;
        },
        builder: (context, authState) {
          final isAuthenticated =
              authState.mapOrNull(authenticated: (_) => true) ?? false;

          return MultiBlocProvider(
            key: ValueKey(isAuthenticated),
            providers: [
              BlocProvider(create: (_) => getIt<HomeBloc>()),
              BlocProvider(
                create: (_) =>
                    getIt<CatalogLookupBloc>()
                      ..add(const CatalogLookupEvent.getDomainsRef()),
              ),
            ],
            child: MaterialApp.router(
              title: 'Multi Catalog System',
              scaffoldMessengerKey: scaffoldMessengerKey,
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
        },
      ),
    );
  }
}
