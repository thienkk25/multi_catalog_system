import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';

class SystemHistoryPage extends StatefulWidget {
  const SystemHistoryPage({super.key});

  @override
  State<SystemHistoryPage> createState() => _SystemHistoryPageState();
}

class _SystemHistoryPageState extends State<SystemHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        spacing: 10,
        children: [
          CustomInput(hintText: 'Tìm kiếm...', suffixIcon: Icon(Icons.search)),
        ],
      ),
    );
  }
}
