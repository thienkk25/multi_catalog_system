import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/presentation.dart';
import 'package:multi_catalog_system/features/import_file/presentation/pages/import_file_page.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DomainManagementBloc>().add(
        const DomainManagementEvent.getAll(),
      );
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
    final bloc = context.read<DomainManagementBloc>();
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
                  if (_debounce?.isActive ?? false) _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    if (search.isEmpty) {
                      context.read<DomainManagementBloc>().add(
                        const DomainManagementEvent.getAll(),
                      );
                    } else {
                      context.read<DomainManagementBloc>().add(
                        DomainManagementEvent.getAll(search: search),
                      );
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
                                context.read<DomainManagementBloc>().add(
                                  const DomainManagementEvent.getAll(),
                                );
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImportFilePage(typeImport: 1),
              ),
            );
          },
          onPressedAdd: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: bloc,
                  child: const DomainManagementFormPage(
                    type: DomainFormType.create,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
