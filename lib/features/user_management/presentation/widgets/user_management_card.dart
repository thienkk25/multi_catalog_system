import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_label.dart';

class UserManagementCard extends StatelessWidget {
  const UserManagementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(radius: 30),
          Expanded(
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Email', style: TextStyle(color: Colors.grey[600])),
                CustomLabel(text: 'Admin', color: Colors.blue),
              ],
            ),
          ),
          PopupMenuButton(
            icon: SvgPicture.asset(
              'assets/icons/menu-vertical-menu-dots-more-svgrepo-com.svg',
              width: 20,
              height: 20,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: _UserCardMenu(onEdit: () {}, onDelete: () {}),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserCardMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _UserCardMenu({required this.onEdit, required this.onDelete});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Chỉnh sửa'),
            ),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onDelete,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Xóa'),
            ),
          ),
        ),
      ],
    );
  }
}
