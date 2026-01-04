import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/widgets/error_retry_widget.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/presentation.dart';

class ApiKeyManagementPermissionFieldWidget extends StatefulWidget {
  final List<String> fields;
  final bool isView;
  const ApiKeyManagementPermissionFieldWidget({
    super.key,
    required this.fields,
    required this.isView,
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
                  deleteIcon: widget.isView
                      ? null
                      : const Icon(Icons.close, size: 18),
                  onDeleted: widget.isView
                      ? null
                      : () {
                          setState(() => widget.fields.remove(field));
                        },
                  backgroundColor: Colors.blue.shade50,
                  side: BorderSide(color: Colors.blue.shade200),
                ),
              ),
              if (!widget.isView)
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
                  onPressed: () {
                    _showAddFieldDialog();
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddFieldDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: BlocBuilder<CatalogLookupBloc, CatalogLookupState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              return Center(
                child: ErrorRetryWidget(
                  error: state.error!,
                  onRetry: () {
                    context.read<CatalogLookupBloc>().add(
                      const CatalogLookupEvent.getDomainsRef(),
                    );
                  },
                ),
              );
            }

            return ListView(
              children: context.read<CatalogLookupBloc>().state.domainsRef.map((
                e,
              ) {
                return ListTile(
                  title: Text('Lĩnh vực: ${e.name} (${e.code})'),
                  onTap: () {
                    if (!widget.fields.contains(e.code)) {
                      setState(() => widget.fields.add(e.code));
                    }
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
