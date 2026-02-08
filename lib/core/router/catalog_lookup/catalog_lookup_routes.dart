import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/pages/catalog_lookup_page.dart';

class CatalogLookupRoutes {
  static List<RouteBase> routes = [
    ShellRoute(
      builder: (context, state, child) => child,
      routes: [
        GoRoute(
          path: '/',
          name: RouterNames.home,
          builder: (context, state) => const CategoryLookupPage(),
        ),
      ],
    ),
  ];
}
