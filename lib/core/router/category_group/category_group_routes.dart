import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';
import 'package:multi_catalog_system/features/category_group/presentation/presentation.dart';

class CategoryGroupRoutes {
  static List<GoRoute> get routes => [
    GoRoute(
      path: RouterPaths.categoryGroups,
      name: RouterNames.categoryGroups,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<CategoryGroupBloc>(),
        child: const CategoryGroupPage(),
      ),
    ),
    GoRoute(
      path: RouterPaths.categoryGroupForm,
      name: RouterNames.categoryGroupForm,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return BlocProvider.value(
          value: data['bloc'] as CategoryGroupBloc,
          child: CategoryGroupFormPage(
            entry: data['entry'] as CategoryGroupEntry?,
          ),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.categoryGroupDetail,
      name: RouterNames.categoryGroupDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BlocProvider(
          create: (context) =>
              getIt<CategoryGroupBloc>()
                ..add(CategoryGroupEvent.getById(id: id)),
          child: CategoryGroupDetailPage(),
        );
      },
    ),
  ];
}
