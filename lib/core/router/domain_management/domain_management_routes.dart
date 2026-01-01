import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/presentation.dart';

class DomainManagementRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: RouterPaths.domainDetail,
      name: RouterNames.domainDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final entry = state.extra as DomainEntry;

        return BlocProvider(
          create: (_) =>
              getIt<DomainManagementBloc>()
                ..add(DomainManagementEvent.getById(id: id)),
          child: DomainManagementFormPage(
            type: DomainFormType.detail,
            entry: entry,
          ),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.domainCreate,
      name: RouterNames.domainCreate,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => getIt<DomainManagementBloc>(),
          child: const DomainManagementFormPage(type: DomainFormType.create),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.domainUpdate,
      name: RouterNames.domainUpdate,
      builder: (context, state) {
        final entry = state.extra as DomainEntry;
        return BlocProvider(
          create: (_) => getIt<DomainManagementBloc>(),
          child: DomainManagementFormPage(
            type: DomainFormType.update,
            entry: entry,
          ),
        );
      },
    ),
  ];
}
