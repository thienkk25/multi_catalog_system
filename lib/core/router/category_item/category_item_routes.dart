import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_lookup_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/presentation.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_lookup_bloc.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_bloc.dart';

class CategoryItemRoutes {
  static List<RouteBase> routes = [
    ShellRoute(
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<CategoryItemBloc>()),
            BlocProvider(create: (_) => getIt<CategoryItemVersionBloc>()),
            BlocProvider(create: (_) => getIt<DomainLookupBloc>()),
            BlocProvider(create: (_) => getIt<CategoryGroupLookupBloc>()),
          ],
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/category-items',
          name: RouterNames.categoryItem,
          builder: (context, state) => const CategoryItemPage(),
          routes: [
            GoRoute(
              path: '/id/:id',
              name: RouterNames.categoryItemDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;

                return CategoryItemDetailPage(id: id);
              },
            ),
            GoRoute(
              path: 'form',
              name: RouterNames.categoryItemForm,
              builder: (context, state) {
                final mode = state.uri.queryParameters['mode']!;
                final itemId = state.uri.queryParameters['itemId'];
                final versionId = state.uri.queryParameters['versionId'];

                return MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => getIt.get<DomainLookupBloc>()),
                    BlocProvider(
                      create: (_) => getIt.get<CategoryGroupLookupBloc>(),
                    ),
                  ],
                  child: CategoryItemFormPage(
                    mode: CategoryItemFormMode.values.byName(mode),
                    itemId: itemId,
                    versionId: versionId,
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: 'add-legal-documents',
                  name: RouterNames.categoryItemFormAddLegalDocuments,
                  builder: (context, state) {
                    final legalDocuments =
                        state.extra as List<LegalDocumentEntry>?;
                    return BlocProvider(
                      create: (_) => getIt<LegalDocumentBloc>(),
                      child: CategoryItemAddLegalDocumentsPage(
                        legalDocuments: legalDocuments,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];
}
