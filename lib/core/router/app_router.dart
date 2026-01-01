import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/features/features.dart';

import 'auth/auth_routes.dart';
import 'domain_management/domain_management_routes.dart';
import 'home/home_routes.dart';
import 'import_file/import_file_routes.dart';
import 'profile/profile_routes.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      ...HomeRoutes.routes,
      ...AuthRoutes.routes,
      ...DomainManagementRoutes.routes,
      ...ImportFileRoutes.routes,
      ...ProfileRoutes.routes,
    ],
    errorBuilder: (_, state) => const NotFoundPage(),
  );
}
