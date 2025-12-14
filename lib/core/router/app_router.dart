import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/features/features.dart';
import 'router_names.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: RouterNames.home, builder: (_, state) => HomePage()),
      GoRoute(
        path: RouterNames.domainManagement,
        builder: (_, state) => DomainManagementPage(),
      ),
    ],
    // errorBuilder: (_, state) => const NotFoundPage(),
  );
}
