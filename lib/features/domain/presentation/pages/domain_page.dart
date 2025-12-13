import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/domain/presentation/presentation.dart';

class DomainPage extends StatefulWidget {
  const DomainPage({super.key});

  @override
  State<DomainPage> createState() => _DomainPageState();
}

class _DomainPageState extends State<DomainPage> {
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
              Expanded(child: DomainGridView()),
            ],
          ),
        ),
        CustomFloatingActionButton(onPressedImport: () {}, onPressedAdd: () {}),
      ],
    );
  }
}
