import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/import_file/presentation/pages/import_file_page.dart';

class ImportFileRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: RouterPaths.importFile,
      name: RouterNames.importFile,
      builder: (_, state) {
        final type = state.extra as int;
        return ImportFilePage(typeImport: type);
      },
    ),
  ];
}
