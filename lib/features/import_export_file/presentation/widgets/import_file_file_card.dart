import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/utils/formatter/file_size_formatter.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/file_icon_widget.dart';

class ImportFileFileCard extends StatelessWidget {
  final Map<String, dynamic> fileInfo;
  final VoidCallback? onRemove;
  const ImportFileFileCard({super.key, required this.fileInfo, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          FileIconWidget(fileName: fileInfo['name']),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileInfo['name'],
                  style: TextStyle(fontWeight: FontWeight(600), fontSize: 16),
                ),
                Text(
                  formatFileSize(fileInfo['file_size']),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(onPressed: onRemove, icon: Icon(Icons.close)),
        ],
      ),
    );
  }
}
