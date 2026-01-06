import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/presentation.dart';

class DomainManagementPage extends StatefulWidget {
  const DomainManagementPage({super.key});

  @override
  State<DomainManagementPage> createState() => _DomainManagementPageState();
}

class _DomainManagementPageState extends State<DomainManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late final DomainManagementBloc bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc = context.read<DomainManagementBloc>();
      bloc.add(const DomainManagementEvent.getAll());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 10,
            children: [
              CustomInput(
                controller: _searchController,
                hintText: 'Tìm kiếm lĩnh vực',
                suffixIcon: Icon(Icons.search),
                onChanged: (value) {
                  final search = value.trim();
                  if (_debounce?.isActive ?? false) {
                    _debounce?.cancel();
                  }
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    if (search.isEmpty) {
                      bloc.add(const DomainManagementEvent.getAll());
                    } else {
                      bloc.add(DomainManagementEvent.getAll(search: search));
                    }
                  });
                },
              ),
              Expanded(
                child:
                    BlocConsumer<DomainManagementBloc, DomainManagementState>(
                      listener: (context, state) {
                        if (state.successMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.successMessage!),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return state.when((
                          isLoading,
                          entities,
                          error,
                          successMessage,
                        ) {
                          if (isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (error != null) {
                            return ErrorRetryWidget(
                              error: error,
                              onRetry: () {
                                bloc.add(const DomainManagementEvent.getAll());
                              },
                            );
                          }
                          return DomainManagementGridView(domains: entities);
                        });
                      },
                    ),
              ),
            ],
          ),
        ),
        CustomFloatingActionButton(
          onPressedImport: () {
            context.pushNamed(RouterNames.importFile, extra: 1);
          },
          onPressedAdd: () {
            context.pushNamed(
              RouterNames.domainForm,
              extra: {'bloc': bloc, 'type': DomainFormType.create},
            );
          },
        ),
      ],
    );
  }
}
