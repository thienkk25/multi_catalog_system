import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_lookup_bloc.dart';
import 'package:multi_catalog_system/features/user_management/presentation/pages/user_management_add_domains_page.dart';

class OthersRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: '/user-management/add-domains',
      name: RouterNames.userManagementAddDomains,
      builder: (context, state) {
        final fields = (state.extra as List?)?.cast<DomainRefEntry>() ?? [];

        return BlocProvider(
          create: (_) => getIt<DomainLookupBloc>(),
          child: UserManagementAddDomainsPage(fields: fields),
        );
      },
    ),
  ];
}
