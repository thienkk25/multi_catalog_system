import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/features/features.dart';
import 'router_names.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: RouterNames.home,
        builder: (_, state) =>
            BlocProvider(create: (_) => HomeBloc(), child: HomePage()),
      ),
    ],
    // errorBuilder: (_, state) => const NotFoundPage(),
  );
}
