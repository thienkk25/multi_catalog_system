import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_dropdown_button.dart';
import 'package:multi_catalog_system/core/widgets/overlay_dropdown_load_button.dart';
import 'package:multi_catalog_system/features/features.dart';

class CategoryGroupFilterSearchWidget extends StatefulWidget {
  final String? search;
  final Map<String, dynamic> filter;
  const CategoryGroupFilterSearchWidget({
    super.key,
    this.search,
    required this.filter,
  });

  @override
  State<CategoryGroupFilterSearchWidget> createState() =>
      _CategoryGroupFilterSearchWidgetState();
}

class _CategoryGroupFilterSearchWidgetState
    extends State<CategoryGroupFilterSearchWidget> {
  late final DomainLookupBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = context.domainLookupBloc;
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
                  label: Text('Lĩnh vực'),
                  entries: state.entries,
                  selected: state.selectedEntries.firstOrNull,
                  itemLabel: (item) => item.name!,
                  hasMore: state.hasMore,
                  isLoadingMore: state.isLoadingMore,
                  onLoadMore: () {
                    bloc.add(const DomainLookupEvent.loadMore());
                  },
                  onSelected: (value) {
                    bloc.add(
                      DomainLookupEvent.selectedEntries(entries: [value]),
                    );
                    setState(() {
                      widget.filter['domain_id'] = value.id;
                    });
                  },
                );
              },
            ),
            SizedBox(height: 16),
            CustomDropdownButton(
              lable: Text('Loại sắp xếp'),
              hint: '---',
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
                  widget.filter['sortBy'] = value;
                });
              },
            ),
            SizedBox(height: 16),
            CustomDropdownButton(
              lable: Text('Sắp xếp theo'),
              hint: '---',
              items: [
                DropdownMenuItem(value: 'asc', child: Text('Tăng dần')),
                DropdownMenuItem(value: 'desc', child: Text('Giảm dần')),
              ],
              onChanged: (value) {
                setState(() {
                  widget.filter['sort'] = value;
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
                      widget.filter.clear();
                      context.pop();
                      context.groupBloc.add(
                        CategoryGroupEvent.getAll(
                          search: widget.search,
                          filter: widget.filter,
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
                          search: widget.search,
                          filter: widget.filter,
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
