import 'package:flutter/material.dart';

import 'custom_card.dart';

class ListFileCardWidget extends StatefulWidget {
  const ListFileCardWidget({
    super.key,
    required this.data,
    this.icon,
    required this.onClose,
  });
  final List<Map> data;
  final Widget? icon;
  final bool onClose;

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
            _getFileIcon(widget.data[index]['name']),

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
                    _formatFileSize(widget.data[index]['file_size']),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (widget.onClose)
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

String _formatFileSize(int bytes, {int decimals = 2}) {
  if (bytes <= 0) return '0 B';

  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
  int i = 0;
  double size = bytes.toDouble();

  while (size >= 1024 && i < suffixes.length - 1) {
    size /= 1024;
    i++;
  }

  return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
}

Widget _getFileIcon(String fileName) {
  final ext = fileName.split('.').last.toLowerCase();

  late IconData icon;
  late Color color;

  switch (ext) {
    case 'pdf':
      icon = Icons.picture_as_pdf;
      color = Colors.red;
      break;

    case 'doc':
    case 'docx':
      icon = Icons.description;
      color = Colors.blue;
      break;

    case 'xls':
    case 'xlsx':
      icon = Icons.table_chart;
      color = Colors.green;
      break;

    default:
      icon = Icons.insert_drive_file;
      color = Colors.grey;
  }

  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: color.withValues(alpha: .15),
    ),
    child: Icon(icon, color: color),
  );
}
