import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/domain_management/domain/domain.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_event.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_state.dart';

class DomainManagementBloc
    extends Bloc<DomainManagementEvent, DomainManagementState> {
  final CreateDomainUseCase createDomainUseCase;
  final CreateManyDomainUseCase createManyDomainUseCase;
  final UpdateDomainUseCase updateDomainUseCase;
  final DeleteDomainUseCase deleteDomainUseCase;
  final GetByIdDomainUseCase getByIdDomainUseCase;
  final GetAllDomainUseCase getAllDomainUseCase;
  final UpsertManyDomainUseCase upsertManyDomainUseCase;

  DomainManagementBloc({
    required this.createDomainUseCase,
    required this.updateDomainUseCase,
    required this.deleteDomainUseCase,
    required this.getByIdDomainUseCase,
    required this.getAllDomainUseCase,
    required this.upsertManyDomainUseCase,
    required this.createManyDomainUseCase,
  }) : super(const DomainManagementState.initial()) {
    on<DomainManagementEvent>((event, emit) async {
      emit(const DomainManagementState.loading());

      await event.map(
        getAll: (_) async {
          final result = await getAllDomainUseCase();
          result.fold(
            (failure) => emit(
              DomainManagementState.error(message: _mapFailure(failure)),
            ),
            (domains) => emit(DomainManagementState.loaded(domains: domains)),
          );
        },
        getById: (e) async {
          final result = await getByIdDomainUseCase(e.id);
          result.fold(
            (failure) => emit(
              DomainManagementState.error(message: _mapFailure(failure)),
            ),
            (domain) => emit(DomainManagementState.loaded(domains: [domain])),
          );
        },
        create: (e) async {
          final result = await createDomainUseCase(e.domain);
          result.fold(
            (failure) => emit(
              DomainManagementState.error(message: _mapFailure(failure)),
            ),
            (domain) => emit(DomainManagementState.loaded(domains: [domain])),
          );
        },
        createMany: (e) async {
          final result = await createManyDomainUseCase(e.domains);
          result.fold(
            (failure) => emit(
              DomainManagementState.error(message: _mapFailure(failure)),
            ),
            (domains) => emit(DomainManagementState.loaded(domains: domains)),
          );
        },
        update: (e) async {
          final result = await updateDomainUseCase(e.domain);
          result.fold(
            (failure) => emit(
              DomainManagementState.error(message: _mapFailure(failure)),
            ),
            (domain) => emit(DomainManagementState.loaded(domains: [domain])),
          );
        },
        delete: (e) async {
          final result = await deleteDomainUseCase(e.id);
          result.fold(
            (failure) => emit(
              DomainManagementState.error(message: _mapFailure(failure)),
            ),
            (_) async {
              final updatedDomains = await getAllDomainUseCase();
              updatedDomains.fold(
                (failure) => emit(
                  DomainManagementState.error(message: _mapFailure(failure)),
                ),
                (domains) =>
                    emit(DomainManagementState.loaded(domains: domains)),
              );
            },
          );
        },
        upsertMany: (e) async {
          final result = await upsertManyDomainUseCase(e.domains);
          result.fold(
            (failure) => emit(
              DomainManagementState.error(message: _mapFailure(failure)),
            ),
            (domains) => emit(DomainManagementState.loaded(domains: domains)),
          );
        },
      );
    });
  }

  /// Helper map Failure -> message
  String _mapFailure(Failure failure) {
    if (failure is ServerFailure) return failure.message;
    if (failure is CacheFailure) return failure.message;
    if (failure is UnexpectedFailure) return failure.message;
    return 'Unknown error';
  }
}
