import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/profile/presentation/pages/profile_page.dart';

class ProfileRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: RouterPaths.profile,
      name: RouterNames.profile,
      builder: (_, state) => ProfilePage(),
    ),
  ];
}
