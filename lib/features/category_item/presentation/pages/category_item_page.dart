import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/category_item/presentation/presentation.dart';

class CategoryItemPage extends StatefulWidget {
  const CategoryItemPage({super.key});

  @override
  State<CategoryItemPage> createState() => _CategoryItemPageState();
}

class _CategoryItemPageState extends State<CategoryItemPage> {
  bool selectionMode = false;

  final List<CategoryItem> items = List.generate(
    20,
    (i) => CategoryItem(id: i, name: 'Sản phẩm $i'),
  );

  void _toggleSelect(CategoryItem item) {
    setState(() {
      item.isSelected = !item.isSelected;

      selectionMode = items.any((e) => e.isSelected);
    });
  }

  void _toggleSelectAll() {
    setState(() {
      final isAllSelected = items.every((e) => e.isSelected);

      for (final item in items) {
        item.isSelected = !isAllSelected;
      }

      selectionMode = items.any((e) => e.isSelected);
    });
  }

  void _deleteSelected() {
    setState(() {
      items.removeWhere((e) => e.isSelected);
      selectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = items.where((e) => e.isSelected).length;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 10,
            children: [
              CustomInput(
                hintText: 'Tìm kiếm theo tên, mã...',
                icon: Icon(Icons.search),
              ),
              if (selectionMode)
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        items.every((e) => e.isSelected)
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: Colors.blue,
                      ),
                      tooltip: items.every((e) => e.isSelected)
                          ? 'Bỏ chọn tất cả'
                          : 'Chọn tất cả',
                      onPressed: _toggleSelectAll,
                    ),
                    Text(
                      'Đã chọn $selectedCount',
                      style: TextStyle(fontWeight: FontWeight(600)),
                    ),
                  ],
                ),
              Expanded(
                child: CategoryItemListViewWidget(
                  items: items,
                  selectionMode: selectionMode,
                  onTap: _toggleSelect,
                  onLongPress: (item) {
                    setState(() {
                      selectionMode = true;
                      item.isSelected = true;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        if (!selectionMode)
          CustomFloatingActionButton(
            onPressedImport: () {},
            onPressedAdd: () {},
          )
        else
          Positioned(
            right: 20,
            bottom: 50,
            child: Row(
              spacing: 10,
              children: [
                if (selectionMode && selectedCount == 1)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      icon: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.edit, color: Colors.white, size: 30),
                      ),
                      onPressed: _deleteSelected,
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(Icons.delete, color: Colors.white, size: 30),
                    ),
                    onPressed: _deleteSelected,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
