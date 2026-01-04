import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/features/features.dart';

import 'api_key_management/api_key_management_routes.dart';
import 'auth/auth_routes.dart';
import 'category_group/category_group_routes.dart';
import 'domain_management/domain_management_routes.dart';
import 'home/home_routes.dart';
import 'import_file/import_file_routes.dart';
import 'profile/profile_routes.dart';
import 'system_history_management/system_history_management_routes.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      ...HomeRoutes.routes,
      ...AuthRoutes.routes,
      ...DomainManagementRoutes.routes,
      ...CategoryGroupRoutes.routes,
      ...ImportFileRoutes.routes,
      ...ProfileRoutes.routes,
      ...ApiKeyManagementRoutes.routes,
      ...SystemHistoryManagementRoutes.routes,
    ],
    errorBuilder: (_, state) => const NotFoundPage(),
  );
}
