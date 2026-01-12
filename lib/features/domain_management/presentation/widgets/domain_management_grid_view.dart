import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/features.dart';

class DomainManagementGridView extends StatelessWidget {
  final List<DomainEntry> domains;

  const DomainManagementGridView({super.key, this.domains = const []});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DomainManagementBloc>();
    double screenWidth(BuildContext context) {
      return MediaQuery.of(context).size.width;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth(context) < 600 ? 2 : 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: domains.length,
      itemBuilder: (context, index) {
        final domain = domains[index];
        return GestureDetector(
          onTap: () => _onView(context: context, entry: domain),
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
                      domain.name!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      domain.description ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                RoleBasedWidget(
                  permission: ['admin', 'domainOfficer'],
                  child: Positioned(
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
                            onEdit: () => _onEdit(
                              context: context,
                              bloc: bloc,
                              entry: domain,
                            ),
                            onDelete: () => _onDelete(
                              context: context,
                              bloc: bloc,
                              entry: domain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onView({required BuildContext context, required DomainEntry entry}) {
    context.pushNamed(
      RouterNames.domainDetail,
      pathParameters: {'id': ?entry.id},
      extra: entry,
    );
  }

  void _onEdit({
    required BuildContext context,
    required DomainManagementBloc bloc,
    required DomainEntry entry,
  }) {
    context.pop();
    context.pushNamed(
      RouterNames.domainForm,
      extra: {'bloc': bloc, 'type': DomainFormType.update, 'entry': entry},
    );
  }

  void _onDelete({
    required BuildContext context,
    required DomainManagementBloc bloc,
    required DomainEntry entry,
  }) {
    context.pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomAlertDialog(
        onConfirm: () {
          final id = entry.id;
          if (id == null) return;
          bloc.add(DomainManagementEvent.delete(id: id));
          context.pop();
        },
      ),
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
