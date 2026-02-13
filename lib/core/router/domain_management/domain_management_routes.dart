import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/presentation.dart';

class DomainManagementRoutes {
  static List<RouteBase> routes = [
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => getIt<DomainManagementBloc>(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/domains',
          name: RouterNames.domains,
          builder: (context, state) => const DomainManagementPage(),
          routes: [
            GoRoute(
              path: 'id/:id',
              name: RouterNames.domainDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                context.domainManagementBloc.add(
                  DomainManagementEvent.getById(id: id),
                );
                return DomainManagementDetailPage();
              },
            ),
            GoRoute(
              path: '/form',
              name: RouterNames.domainForm,
              builder: (context, state) {
                final mode = state.uri.queryParameters['mode']!;
                final id = state.uri.queryParameters['id'];
                return DomainManagementFormPage(
                  mode: DomainManagementFormType.values.byName(mode),
                  id: id,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
