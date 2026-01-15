import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_catalog_system/core/core.dart';

class CatalogLookupInforCardWidget extends StatelessWidget {
  const CatalogLookupInforCardWidget({
    super.key,
    required this.dateTime,
    required this.title,
    required this.subDomain,
    required this.subGroup,
    required this.subDocument,
  });
  final DateTime dateTime;
  final String title;
  final String subDomain;
  final String subGroup;
  final String subDocument;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Text(
            DateFormat('d/M/yy - hh:mm').format(dateTime),
            style: TextStyle(color: Colors.blue),
          ),
          Text(title, style: TextStyle(fontWeight: FontWeight(600))),
          Text(
            'Lĩnh lực: $subDomain / Nhóm: $subGroup',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            'Văn bản: $subDocument',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
