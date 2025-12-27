import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/catalog_lookup/domain/domain.dart';

import 'catalog_lookup_event.dart';
import 'catalog_lookup_state.dart';

class CatalogLookupBloc extends Bloc<CatalogLookupEvent, CatalogLookupState> {
  final SearchCatalogUseCase searchCatalogUseCase;
  final GetDomainRefUseCase getDomainRefUseCase;
  final GetCategoryGroupRefUseCase getCategoryGroupRefUseCase;

  CatalogLookupBloc({
    required this.searchCatalogUseCase,
    required this.getDomainRefUseCase,
    required this.getCategoryGroupRefUseCase,
  }) : super(CatalogLookupState()) {
    on<CatalogLookupEvent>(_onEvent);
  }

  Future<void> _onEvent(
    CatalogLookupEvent event,
    Emitter<CatalogLookupState> emit,
  ) async {
    await event.map(
      getDomainsRef: (v) async {
        emit(state.copyWith(isLoading: true, error: null));

        final result = await getDomainRefUseCase();
        if (emit.isDone) return;

        result.fold(
          (f) => emit(state.copyWith(isLoading: false, error: _mapFailure(f))),
          (entities) => emit(
            state.copyWith(
              isLoading: false,
              domainsRef: entities,
              domainNameMap: {for (final d in entities) d.id: d.name},
            ),
          ),
        );
      },
      getCategoryGroupsRef: (v) async {
        emit(state.copyWith(isLoading: true, error: null));

        final result = await getCategoryGroupRefUseCase(domainId: v.domainId);
        if (emit.isDone) return;

        result.fold(
          (f) => emit(state.copyWith(isLoading: false, error: _mapFailure(f))),
          (entities) => emit(
            state.copyWith(isLoading: false, categoryGroupRef: entities),
          ),
        );
      },
      searchCatalog: (v) async {
        emit(state.copyWith(isLoading: true, error: null));

        final result = await searchCatalogUseCase(
          keyword: v.keyword,
          domainId: v.domainId,
          limit: v.limit,
          offset: v.offset,
        );
        if (emit.isDone) return;

        result.fold(
          (f) => emit(state.copyWith(isLoading: false, error: _mapFailure(f))),
          (entities) =>
              emit(state.copyWith(isLoading: false, catalog: entities)),
        );
      },
    );
  }

  String _mapFailure(Failure failure) {
    if (failure is ServerFailure) return failure.message;
    if (failure is CacheFailure) return failure.message;
    if (failure is UnexpectedFailure) return failure.message;
    return 'Unknown error';
  }
}
