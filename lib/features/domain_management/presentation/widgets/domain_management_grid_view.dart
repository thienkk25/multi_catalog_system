import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_event.dart';
import 'package:multi_catalog_system/features/features.dart';

class DomainManagementGridView extends StatelessWidget {
  final List<DomainEntry> domains;

  const DomainManagementGridView({super.key, this.domains = const []});

  @override
  Widget build(BuildContext context) {
    double screenWidth(BuildContext context) {
      return MediaQuery.of(context).size.width;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth(context) < 600 ? 2 : 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2,
      ),
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: domains.length,
      itemBuilder: (context, index) {
        final domain = domains[index];
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Chi tiết lĩnh vực ${domain.name}'),
                  content: Text(
                    'Mã: ${domain.code}\nMô tả: ${domain.description}',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Đóng'),
                    ),
                  ],
                );
              },
            );
          },
          child: CustomCard(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Text(
                      'Mã: ${domain.code}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      domain.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      domain.description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: PopupMenuButton(
                    icon: SvgPicture.asset(
                      'assets/icons/menu-vertical-menu-dots-more-svgrepo-com.svg',
                      width: 20,
                      height: 20,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: _DomainCardMenu(
                          onEdit: () {
                            Navigator.pop(context);
                          },
                          onDelete: () {
                            Navigator.pop(context);
                            context.read<DomainManagementBloc>().add(
                              DomainManagementEvent.delete(id: domain.id),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DomainCardMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DomainCardMenu({required this.onEdit, required this.onDelete});

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
