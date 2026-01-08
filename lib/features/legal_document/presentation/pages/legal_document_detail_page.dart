import 'package:flutter/material.dart';

class LegalDocumentDetailPage extends StatelessWidget {
  const LegalDocumentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết văn bản pháp lý'),
        centerTitle: true,
      ),
      body: const Center(child: Text('Chi tiết văn bản pháp lý')),
    );
  }
}
