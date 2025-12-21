import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/presentation.dart';
import 'package:multi_catalog_system/features/import_file/presentation/pages/import_file_page.dart';

import '../bloc/domain_management_event.dart';
import '../bloc/domain_management_state.dart';

class DomainManagementPage extends StatefulWidget {
  const DomainManagementPage({super.key});

  @override
  State<DomainManagementPage> createState() => _DomainManagementPageState();
}

class _DomainManagementPageState extends State<DomainManagementPage> {
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
  Widget build(BuildContext context) {
    final bloc = context.read<DomainManagementBloc>();
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 10,
            children: [
              CustomInput(
                hintText: 'Tìm kiếm lĩnh vực',
                suffixIcon: Icon(Icons.search),
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
                          domains,
                          error,
                          successMessage,
                        ) {
                          if (isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (error != null) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 20,
                              children: [
                                Text(
                                  error,
                                  style: TextStyle(color: Colors.red),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: CustomButton(
                                    onTap: () {
                                      context.read<DomainManagementBloc>().add(
                                        const DomainManagementEvent.getAll(),
                                      );
                                    },
                                    colorBackground: Colors.red,
                                    textButton: Text(
                                      'Thử lại',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return DomainManagementGridView(domains: domains);
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
                  child: const DomainManagementViewAddEditPage(type: Type.add),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
