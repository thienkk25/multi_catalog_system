import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_catalog_system/core/core.dart';

class CategoryItemListViewWidget extends StatelessWidget {
  const CategoryItemListViewWidget({
    super.key,
    required this.items,
    required this.selectionMode,
    required this.onTap,
    required this.onLongPress,
  });

  final List<CategoryItem> items;
  final bool selectionMode;
  final Function(CategoryItem) onTap;
  final Function(CategoryItem) onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return GestureDetector(
          onLongPress: () => onLongPress(item),
          onTap: selectionMode ? () => onTap(item) : null,
          child: CustomCard(
            color: item.isSelected ? Colors.blue.withValues(alpha: .1) : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Row(
                  children: [
                    if (selectionMode)
                      Icon(
                        item.isSelected
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: Colors.blue,
                      ),
                    if (selectionMode) SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tên: ${item.name}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CustomLabel(color: Colors.green, text: 'Hoạt động'),
                  ],
                ),
                Text('Mã: SP${item.id}'),
                Text('Lĩnh vực: Lĩnh vực A | Nhóm: Nhóm 1'),
                Text('Mô tả: Đây là mô tả của ${item.name}'),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => SizedBox(height: 10),
    );
  }
}

class CategoryItem {
  final int id;
  final String name;
  bool isSelected;

  CategoryItem({required this.id, required this.name, this.isSelected = false});
}
