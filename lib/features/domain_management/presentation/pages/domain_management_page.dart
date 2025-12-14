import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/presentation.dart';

class DomainManagementPage extends StatefulWidget {
  const DomainManagementPage({super.key});

  @override
  State<DomainManagementPage> createState() => _DomainManagementPageState();
}

class _DomainManagementPageState extends State<DomainManagementPage> {
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
                icon: Icon(Icons.search),
              ),
              Expanded(child: DomainManagementGridView()),
            ],
          ),
        ),
        CustomFloatingActionButton(onPressedImport: () {}, onPressedAdd: () {}),
      ],
    );
  }
}
