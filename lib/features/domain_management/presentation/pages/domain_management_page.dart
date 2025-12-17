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
                child: BlocBuilder<DomainManagementBloc, DomainManagementState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () =>
                          const Center(child: Text('Chưa có dữ liệu')),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      loaded: (domains) =>
                          DomainManagementGridView(domains: domains),
                      error: (message) => Center(child: Text(message)),
                    );
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
                builder: (context) =>
                    const DomainManagementAddEditPage(isEdit: false),
              ),
            );
          },
        ),
      ],
    );
  }
}
