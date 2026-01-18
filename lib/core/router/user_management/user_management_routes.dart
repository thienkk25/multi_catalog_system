import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/user_management/presentation/presentation.dart';

class UserManagementRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: RouterPaths.userManagement,
      name: RouterNames.userManagement,
      builder: (context, state) => const UserManagementPage(),
    ),
  ];
}
