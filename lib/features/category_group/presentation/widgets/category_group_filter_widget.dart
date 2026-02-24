import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_dropdown_button.dart';
import 'package:multi_catalog_system/core/widgets/overlay_dropdown_load_button.dart';
import 'package:multi_catalog_system/features/features.dart';

class CategoryGroupFilterWidget extends StatefulWidget {
  const CategoryGroupFilterWidget({super.key});

  @override
  State<CategoryGroupFilterWidget> createState() =>
      _CategoryGroupFilterWidgetState();
}

class _CategoryGroupFilterWidgetState extends State<CategoryGroupFilterWidget> {
  String? _domainId;
  String? _sortBy;
  String? _sort;

  @override
  void initState() {
    super.initState();
    _sortBy = context.groupBloc.state.sortBy ?? 'code';
    _sort = context.groupBloc.state.sort ?? 'asc';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Bộ lọc tìm kiếm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ],
            ),
            SizedBox(height: 16),

            BlocBuilder<DomainLookupBloc, DomainLookupState>(
              builder: (context, state) {
                return OverlayDropdownLoadButton<DomainRefEntry>(
                  isMulti: false,
                  label: Text('Lĩnh vực'),
                  entries: state.entries,
                  selected: state.selectedEntries.firstOrNull,
                  itemLabel: (item) => item.name!,
                  hasMore: state.hasMore,
                  isLoadingMore: state.isLoadingMore,
                  onLoadMore: () {
                    context.domainLookupBloc.add(
                      const DomainLookupEvent.loadMore(),
                    );
                  },
                  onSelected: (value) {
                    context.domainLookupBloc.add(
                      DomainLookupEvent.selectedEntries(entries: [value]),
                    );
                    setState(() {
                      _domainId = value.id;
                    });
                  },
                );
              },
            ),
            SizedBox(height: 16),
            CustomDropdownButton(
              lable: Text('Loại sắp xếp'),
              value: _sortBy,
              items: [
                DropdownMenuItem(value: 'code', child: Text('Mã nhóm')),
                DropdownMenuItem(value: 'name', child: Text('Tên nhóm')),
                DropdownMenuItem(value: 'created_at', child: Text('Ngày tạo')),
                DropdownMenuItem(
                  value: 'updated_at',
                  child: Text('Ngày cập nhật'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _sortBy = value;
                });
              },
            ),
            SizedBox(height: 16),
            CustomDropdownButton(
              lable: Text('Sắp xếp theo'),
              value: _sort,
              items: [
                DropdownMenuItem(value: 'asc', child: Text('Tăng dần')),
                DropdownMenuItem(value: 'desc', child: Text('Giảm dần')),
              ],
              onChanged: (value) {
                setState(() {
                  _sort = value;
                });
              },
            ),
            SizedBox(height: 24),
            Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      context.pop();
                      context.domainLookupBloc.add(
                        DomainLookupEvent.selectedEntries(entries: []),
                      );
                      context.groupBloc.add(
                        CategoryGroupEvent.getAll(
                          search: context.groupBloc.state.search,
                        ),
                      );
                    },
                    colorBackground: Colors.grey,
                    textButton: Text(
                      'Xóa bộ lọc',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      context.pop();
                      context.groupBloc.add(
                        CategoryGroupEvent.getAll(
                          search: context.groupBloc.state.search,
                          filter: {'domain_id': _domainId},
                          sortBy: _sortBy,
                          sort: _sort,
                        ),
                      );
                    },
                    colorBackground: Colors.blue,
                    textButton: Text(
                      'Áp dụng',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
