import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/features/features.dart';
import 'router_names.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: RouterNames.home, builder: (_, state) => HomePage()),
    ],
    // errorBuilder: (_, state) => const NotFoundPage(),
  );
}
