import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/domain/entities/category_group/category_group_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_dropdown_button.dart';
import 'package:multi_catalog_system/core/widgets/overlay_dropdown_load_button.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_lookup_bloc.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_lookup_event.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_lookup_state.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_event.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_lookup_bloc.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_lookup_event.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_lookup_state.dart';

class CategoryItemFilterWidget extends StatefulWidget {
  final VoidCallback onClose;
  const CategoryItemFilterWidget({super.key, required this.onClose});

  @override
  State<CategoryItemFilterWidget> createState() =>
      _CategoryItemFilterWidgetState();
}

class _CategoryItemFilterWidgetState extends State<CategoryItemFilterWidget> {
  String? _selectedStatus;
  String _sortBy = 'created_at';
  String _sort = 'desc';

  late final CategoryItemBloc _itemBloc;
  late final DomainLookupBloc _domainLookupBloc;
  late final CategoryGroupLookupBloc _groupLookupBloc;

  @override
  void initState() {
    super.initState();
    _itemBloc = context.itemBloc;
    _domainLookupBloc = context.domainLookupBloc;
    _groupLookupBloc = context.categoryGroupLookupBloc;

    _domainLookupBloc.add(const DomainLookupEvent.lookup());
  }

  void _loadDataGroup(List<String> domainIds) {
    _groupLookupBloc.add(CategoryGroupLookupEvent.lookup(domainIds: domainIds));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              children: [
                Text(
                  'Bộ lọc',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.keyboard_double_arrow_left),
                  onPressed: () => widget.onClose(),
                ),
              ],
            ),
            BlocBuilder<DomainLookupBloc, DomainLookupState>(
              builder: (context, state) {
                return OverlayDropdownLoadButton<DomainRefEntry>(
                  isMulti: true,
                  label: Text('Lĩnh vực'),
                  maxWidthOverlay: 280,
                  entries: state.entries,
                  selectedValues: state.selectedEntries,
                  itemLabel: (item) => item.name!,
                  hasMore: state.hasMore,
                  isLoadingMore: state.isLoadingMore,
                  onLoadMore: () {
                    _domainLookupBloc.add(const DomainLookupEvent.loadMore());
                  },
                  onMultiSelected: (value) {
                    _domainLookupBloc.add(
                      DomainLookupEvent.selectedEntries(entries: value),
                    );
                  },
                  onToggle: (value) {
                    if (!value) {
                      _loadDataGroup(
                        _domainLookupBloc.state.selectedEntries
                            .map((e) => e.id!)
                            .toList(),
                      );
                    }
                  },
                );
              },
            ),
            BlocBuilder<CategoryGroupLookupBloc, CategoryGroupLookupState>(
              builder: (context, state) {
                return OverlayDropdownLoadButton<CategoryGroupRefEntry>(
                  isMulti: true,
                  label: Text('Nhóm danh mục'),
                  maxWidthOverlay: 280,
                  entries: state.entries,
                  selectedValues: state.selectedEntries,
                  itemLabel: (item) => item.name!,
                  hasMore: state.hasMore,
                  isLoadingMore: state.isLoadingMore,
                  onLoadMore: () {
                    _groupLookupBloc.add(
                      const CategoryGroupLookupEvent.loadMore(),
                    );
                  },
                  onMultiSelected: (value) {
                    _groupLookupBloc.add(
                      CategoryGroupLookupEvent.selectedEntries(entries: value),
                    );
                  },
                );
              },
            ),

            CustomDropdownButton<String>(
              hint: 'Trạng thái',
              value: _selectedStatus,
              items: const [
                DropdownMenuItem(value: null, child: Text('Tất cả trạng thái')),
                DropdownMenuItem(value: 'active', child: Text('Hoạt động')),
                DropdownMenuItem(
                  value: 'inactive',
                  child: Text('Ngừng hoạt động'),
                ),
              ],
              onChanged: (value) {
                setState(() => _selectedStatus = value);
              },
            ),

            CustomDropdownButton<String>(
              value: '$_sortBy|$_sort',
              items: const [
                DropdownMenuItem(
                  value: 'created_at|desc',
                  child: Text('Ngày tạo (mới nhất)'),
                ),
                DropdownMenuItem(
                  value: 'created_at|asc',
                  child: Text('Ngày tạo (cũ nhất)'),
                ),
                DropdownMenuItem(value: 'name|asc', child: Text('Tên (A → Z)')),
                DropdownMenuItem(
                  value: 'name|desc',
                  child: Text('Tên (Z → A)'),
                ),
                DropdownMenuItem(value: 'code|asc', child: Text('Mã (A → Z)')),
                DropdownMenuItem(value: 'code|desc', child: Text('Mã (Z → A)')),
              ],
              onChanged: (value) {
                if (value == null) return;

                final parts = value.split('|');
                setState(() {
                  _sortBy = parts[0];
                  _sort = parts[1];
                });
              },
            ),
            SizedBox(height: 50),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: CustomButton(
                    colorBackground: Colors.transparent,
                    colorBorder: Colors.blue.withValues(alpha: .5),
                    textButton: const Text('Đặt lại'),
                    onTap: () {
                      _domainLookupBloc.add(
                        const DomainLookupEvent.selectedEntries(entries: []),
                      );
                      _groupLookupBloc.add(
                        const CategoryGroupLookupEvent.selectedEntries(
                          entries: [],
                        ),
                      );
                      setState(() {
                        _selectedStatus = null;
                        _sortBy = 'created_at';
                        _sort = 'desc';
                      });
                      _itemBloc.add(
                        CategoryItemEvent.getAll(
                          search: _itemBloc.state.search,
                          sortBy: _sortBy,
                          sort: _sort,
                          filter: {},
                        ),
                      );
                    },
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 100,
                  child: CustomButton(
                    colorBackground: Colors.blue,
                    textButton: const Text(
                      'Xác nhận',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      widget.onClose();
                      _itemBloc.add(
                        CategoryItemEvent.getAll(
                          search: _itemBloc.state.search,
                          sortBy: _sortBy,
                          sort: _sort,
                          filter: {
                            'status': _selectedStatus,
                            'domain_id': _domainLookupBloc.state.selectedEntries
                                .map((e) => e.id)
                                .toList(),
                            'group_id': _groupLookupBloc.state.selectedEntries
                                .map((e) => e.id)
                                .toList(),
                          },
                        ),
                      );
                    },
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
