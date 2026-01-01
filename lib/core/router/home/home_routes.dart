import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/home/presentation/pages/home_page.dart';

class HomeRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: RouterPaths.home,
      name: RouterNames.home,
      builder: (_, state) => HomePage(),
    ),
  ];
}
