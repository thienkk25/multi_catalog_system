import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/aprove/presentation/pages/approve_add_legal_documents_page.dart';
import 'package:multi_catalog_system/features/aprove/presentation/pages/approve_form_page.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_lookup_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';
import 'package:multi_catalog_system/features/aprove/presentation/pages/approve_page.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_lookup_bloc.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_bloc.dart';

class ApproveRoutes {
  static List<RouteBase> routes = [
    ShellRoute(
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<CategoryItemVersionBloc>()),
          ],
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/approve',
          name: RouterNames.approve,
          builder: (context, state) {
            return const ApprovePage();
          },
          routes: [
            GoRoute(
              path: 'form',
              name: RouterNames.approveForm,
              builder: (context, state) {
                final versionId = state.uri.queryParameters['versionId'];

                return MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => getIt.get<DomainLookupBloc>()),
                    BlocProvider(
                      create: (_) => getIt.get<CategoryGroupLookupBloc>(),
                    ),
                  ],
                  child: ApproveFormPage(versionId: versionId!),
                );
              },
              routes: [
                GoRoute(
                  path: 'add-legal-documents',
                  name: RouterNames.approveFormAddLegalDocuments,
                  builder: (context, state) {
                    final legalDocuments =
                        state.extra as List<LegalDocumentEntry>?;
                    return BlocProvider(
                      create: (_) => getIt<LegalDocumentBloc>(),
                      child: ApproveAddLegalDocumentsPage(
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
