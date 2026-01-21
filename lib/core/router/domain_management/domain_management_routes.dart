import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/presentation.dart';

class DomainManagementRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: RouterPaths.domains,
      name: RouterNames.domains,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<DomainManagementBloc>(),
        child: const DomainManagementPage(),
      ),
    ),
    GoRoute(
      path: RouterPaths.domainForm,
      name: RouterNames.domainForm,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return BlocProvider.value(
          value: data['bloc'] as DomainManagementBloc,
          child: DomainManagementFormPage(entry: data['entry'] as DomainEntry?),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.domainDetail,
      name: RouterNames.domainDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BlocProvider(
          create: (_) =>
              getIt<DomainManagementBloc>()
                ..add(DomainManagementEvent.getById(id: id)),
          child: DomainManagementDetailPage(),
        );
      },
    ),
  ];
}
