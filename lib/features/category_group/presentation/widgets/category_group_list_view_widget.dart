import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_bloc.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_extensions.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_state.dart';
import 'package:multi_catalog_system/features/category_group/category_group.dart';

class CategoryGroupListViewWidget extends StatelessWidget {
  const CategoryGroupListViewWidget({super.key, required this.categoryGroup});
  final List<CategoryGroupEntry> categoryGroup;

  @override
  Widget build(BuildContext context) {
    final bloc = context.groupBloc;
    return ListView.separated(
      itemCount: categoryGroup.length,
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _onDetail(context: context, entry: categoryGroup[index]),
          child: CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mã: ${categoryGroup[index].code}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Tên: ${categoryGroup[index].name}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 5),
                BlocSelector<CatalogLookupBloc, CatalogLookupState, String>(
                  selector: (state) =>
                      state.domainNameOf(categoryGroup[index].domainId!),
                  builder: (context, domainName) {
                    return Text(
                      'Lĩnh vực: $domainName',
                      style: TextStyle(color: Colors.grey[600]),
                    );
                  },
                ),
                SizedBox(height: 5),
                RoleBasedWidget(
                  permission: ['admin', 'domainOfficer'],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 10,
                    children: [
                      GestureDetector(
                        onTap: () => _onUpdate(
                          context: context,
                          bloc: bloc,
                          entry: categoryGroup[index],
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.edit, color: Colors.white, size: 12),
                              Text(
                                'Chỉnh sửa',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _onRemove(
                          context: context,
                          bloc: bloc,
                          entry: categoryGroup[index],
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.delete, color: Colors.white, size: 12),
                              Text(
                                'Xóa',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
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

  void _onDetail({
    required BuildContext context,
    required CategoryGroupEntry entry,
  }) {
    context.goNamed(
      RouterNames.categoryGroupDetail,
      pathParameters: {'id': ?entry.id},
    );
  }

  void _onUpdate({
    required BuildContext context,
    required CategoryGroupBloc bloc,
    required CategoryGroupEntry entry,
  }) {
    context.goNamed(
      RouterNames.categoryGroupForm,
      extra: {'bloc': bloc, 'entry': entry},
    );
  }

  void _onRemove({
    required BuildContext context,
    required CategoryGroupBloc bloc,
    required CategoryGroupEntry entry,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertDialog(
          onConfirm: () {
            bloc.add(CategoryGroupEvent.delete(id: entry.id!));
            context.pop();
          },
        );
      },
    );
  }
}
