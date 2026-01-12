import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/utils/formatter/file_size_formatter.dart';
import 'package:multi_catalog_system/core/widgets/file_icon.dart';

import '../../../../core/widgets/custom_card.dart';

class ListFileCardWidget extends StatefulWidget {
  const ListFileCardWidget({super.key, required this.data, this.icon});
  final List<Map> data;
  final Widget? icon;

  @override
  State<ListFileCardWidget> createState() => _ListFileCardWidgetState();
}

class _ListFileCardWidgetState extends State<ListFileCardWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => CustomCard(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            FileIcon(fileName: widget.data[index]['name']),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data[index]['name'],
                    style: TextStyle(fontWeight: FontWeight(600), fontSize: 16),
                  ),
                  Text(
                    formatFileSize(widget.data[index]['file_size']),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  widget.data.removeAt(index);
                });
              },
              icon: Icon(Icons.close),
            ),
          ],
        ),
      ),
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: widget.data.length,
    );
  }
}
