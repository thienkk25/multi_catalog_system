import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entries/legal_document_entry.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/presentation.dart';

class LegalDocumentRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: RouterPaths.legalDocument,
      name: RouterNames.legalDocument,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<LegalDocumentBloc>(),
        child: const LegalDocumentPage(),
      ),
    ),
    GoRoute(
      path: RouterPaths.legalDocumentForm,
      name: RouterNames.legalDocumentForm,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return LegalDocumentFormPage(
          type: data['type'] as LegalDocumentFormPageType,
          entry: data['entry'] as LegalDocumentEntry?,
        );
      },
    ),
    GoRoute(
      path: RouterPaths.legalDocumentDetail,
      name: RouterNames.legalDocumentDetail,
      builder: (context, state) => const LegalDocumentDetailPage(),
    ),
  ];
}
