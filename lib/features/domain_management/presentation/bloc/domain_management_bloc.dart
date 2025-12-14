import 'package:flutter_bloc/flutter_bloc.dart';
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
      await event.map(
        getAll: (_) async {
          emit(const DomainManagementState.loading());
          try {
            final domains = await getAllDomainUseCase();
            emit(DomainManagementState.loaded(domains: domains));
          } catch (e) {
            emit(DomainManagementState.error(message: e.toString()));
          }
        },
        getById: (e) async {
          emit(const DomainManagementState.loading());
          try {
            final domain = await getByIdDomainUseCase(e.id);
            emit(DomainManagementState.loaded(domains: [domain]));
          } catch (e) {
            emit(DomainManagementState.error(message: e.toString()));
          }
        },
        create: (e) async {
          emit(const DomainManagementState.loading());
          try {
            final createdDomain = await createDomainUseCase(e.domain);
            emit(DomainManagementState.loaded(domains: [createdDomain]));
          } catch (e) {
            emit(DomainManagementState.error(message: e.toString()));
          }
        },
        createMany: (e) async {
          emit(const DomainManagementState.loading());
          try {
            final createdDomains = await createManyDomainUseCase(e.domains);
            emit(DomainManagementState.loaded(domains: createdDomains));
          } catch (e) {
            emit(DomainManagementState.error(message: e.toString()));
          }
        },
        update: (e) async {
          emit(const DomainManagementState.loading());
          try {
            final updatedDomain = await updateDomainUseCase(e.domain);
            emit(DomainManagementState.loaded(domains: [updatedDomain]));
          } catch (e) {
            emit(DomainManagementState.error(message: e.toString()));
          }
        },
        delete: (e) async {
          emit(const DomainManagementState.loading());
          try {
            await deleteDomainUseCase(e.id);
            emit(const DomainManagementState.loaded(domains: []));
          } catch (e) {
            emit(DomainManagementState.error(message: e.toString()));
          }
        },
        upsertMany: (e) async {
          emit(const DomainManagementState.loading());
          try {
            final upsertedDomains = await upsertManyDomainUseCase(e.domains);
            emit(DomainManagementState.loaded(domains: upsertedDomains));
          } catch (e) {
            emit(DomainManagementState.error(message: e.toString()));
          }
        },
      );
    });
  }
}
