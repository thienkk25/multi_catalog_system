import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/utils/extensions/auth_permission_extension.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_state.dart';
import 'package:multi_catalog_system/features/import_export_file/presentation/bloc/export_file_bloc.dart';
import 'package:multi_catalog_system/features/import_export_file/presentation/bloc/import_file_bloc.dart';
import 'package:multi_catalog_system/features/import_export_file/presentation/pages/import_export_file_page.dart';

class ImportFileRoutes {
  static List<RouteBase> routes = [
    ShellRoute(
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<ImportFileBloc>()),
            BlocProvider(create: (_) => getIt<ExportFileBloc>()),
          ],
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/import-export-file',
          name: RouterNames.importExportFile,
          builder: (_, state) {
            final typeImport = state.extra as int?;
            return ImportExportFilePage(typeImport: typeImport);
          },
        ),
      ],
      redirect: (context, state) {
        final authState = context.authBloc.state;

        return authState.mapOrNull(
          unauthenticated: (_) => '/login',
          authenticated: (_) {
            if (!context.hasAnyRole(['admin', 'domainOfficer'])) {
              return '/domains';
            }
            return null;
          },
          loading: (_) => null,
        );
      },
    ),
  ];
}
