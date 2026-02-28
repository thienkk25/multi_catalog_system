import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/import_file/presentation/bloc/import_file_bloc.dart';
import 'package:multi_catalog_system/features/import_file/presentation/pages/import_file_page.dart';

class ImportFileRoutes {
  static List<RouteBase> routes = [
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => getIt<ImportFileBloc>(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/import-file',
          name: RouterNames.importFile,
          builder: (_, state) {
            final typeImport = state.extra as int?;
            return ImportFilePage(typeImport: typeImport);
          },
        ),
      ],
    ),
  ];
}
