import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';

class ApiKeyManagementPermissionFieldWidget extends StatefulWidget {
  final List<String> fields;
  final bool isDetail;
  const ApiKeyManagementPermissionFieldWidget({
    super.key,
    required this.fields,
    required this.isDetail,
  });

  @override
  State<ApiKeyManagementPermissionFieldWidget> createState() =>
      _ApiKeyManagementPermissionFieldWidgetState();
}

class _ApiKeyManagementPermissionFieldWidgetState
    extends State<ApiKeyManagementPermissionFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lĩnh vực được phân quyền',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...widget.fields.map(
                (field) => Chip(
                  label: Text(
                    field,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  deleteIcon: widget.isDetail
                      ? null
                      : const Icon(Icons.close, size: 18),
                  onDeleted: widget.isDetail
                      ? null
                      : () {
                          setState(() => widget.fields.remove(field));
                        },
                  backgroundColor: Colors.blue.shade50,
                  side: BorderSide(color: Colors.blue.shade200),
                ),
              ),
              if (!widget.isDetail)
                Row(
                  spacing: 8,
                  children: [
                    ActionChip(
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Chọn thêm lĩnh vực',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.add, size: 18, color: Colors.blue),
                        ],
                      ),
                      backgroundColor: Colors.transparent,
                      side: BorderSide(color: Colors.blue.shade300),
                      onPressed: () async {
                        final result =
                            await context.pushNamed(
                                  RouterNames.apiKeyAddDomains,
                                  extra: widget.fields,
                                )
                                as List<String>?;

                        if (result == null) return;

                        setState(
                          () => widget.fields
                            ..clear()
                            ..addAll(result),
                        );
                      },
                    ),
                    if (widget.fields.isNotEmpty)
                      ActionChip(
                        label: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Xóa tất cả',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.remove, size: 18, color: Colors.blue),
                          ],
                        ),
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: Colors.blue.shade300),
                        onPressed: () {
                          setState(() {
                            widget.fields.clear();
                          });
                        },
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
