import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/presentation.dart';

class LegalDocumentRoutes {
  static List<RouteBase> routes = [
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => getIt<LegalDocumentBloc>(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/legal-document',
          name: RouterNames.legalDocument,
          builder: (context, state) => const LegalDocumentPage(),
          routes: [
            GoRoute(
              path: '/id/:id',
              name: RouterNames.legalDocumentDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                context.legalDocumentBloc.add(
                  LegalDocumentEvent.getById(id: id),
                );
                return LegalDocumentDetailPage();
              },
            ),
            GoRoute(
              path: '/form',
              name: RouterNames.legalDocumentForm,
              builder: (context, state) {
                final mode = state.uri.queryParameters['mode']!;
                final id = state.uri.queryParameters['id'];
                return BlocProvider(
                  create: (_) => getIt<DocumentFileCubit>(),
                  child: LegalDocumentFormPage(
                    mode: LegalDocumentFormType.values.byName(mode),
                    id: id,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
