import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/error_retry_widget.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_bloc.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_event.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_state.dart';

class ApiKeyManagementAddDomainsPage extends StatefulWidget {
  final List<String> fields;

  const ApiKeyManagementAddDomainsPage({super.key, required this.fields});

  @override
  State<ApiKeyManagementAddDomainsPage> createState() =>
      _ApiKeyManagementAddDomainsPageState();
}

class _ApiKeyManagementAddDomainsPageState
    extends State<ApiKeyManagementAddDomainsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _chipScrollController = ScrollController();
  late List<String> _selected;
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.fields);
  }

  bool _isAllSelected(List<String> allCodes) {
    return _selected.length == allCodes.length && allCodes.isNotEmpty;
  }

  void _toggleSelectAll(List<String> allCodes) {
    setState(() {
      if (_isAllSelected(allCodes)) {
        _selected.clear();
      } else {
        _selected = List.from(allCodes);
      }
    });
  }

  void _toggle(String code) {
    setState(() {
      _selected.contains(code) ? _selected.remove(code) : _selected.add(code);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _chipScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Chọn lĩnh vực'),
        centerTitle: true,
        actions: [
          BlocBuilder<CatalogLookupBloc, CatalogLookupState>(
            builder: (context, state) {
              final allCodes = state.domainsRef.map((e) => e.code).toList();
              final isAll = _isAllSelected(allCodes);

              return TextButton(
                onPressed: () => _toggleSelectAll(allCodes),
                child: Text(
                  isAll ? 'Bỏ chọn tất cả' : 'Chọn tất cả',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearch(),
              SizedBox(height: 8),
              _buildSelectedChips(),
              _buildLabel(),
              SizedBox(height: 8),
              Expanded(child: _buildList()),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return CustomInput(
      controller: _searchController,
      hintText: 'Tìm kiếm lĩnh vực...',
      onChanged: (v) => setState(() => _keyword = v.toLowerCase()),
      suffixIcon: Icon(Icons.search),
    );
  }

  Widget _buildSelectedChips() {
    if (_selected.isEmpty) return const SizedBox();

    return SizedBox(
      height: 50,
      child: Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            final newOffset =
                _chipScrollController.offset + event.scrollDelta.dy;

            _chipScrollController.jumpTo(
              newOffset.clamp(
                0.0,
                _chipScrollController.position.maxScrollExtent,
              ),
            );
          }
        },
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            final newOffset = _chipScrollController.offset - details.delta.dx;

            _chipScrollController.jumpTo(
              newOffset.clamp(
                0.0,
                _chipScrollController.position.maxScrollExtent,
              ),
            );
          },
          child: ListView.builder(
            controller: _chipScrollController,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: _selected.length,
            itemBuilder: (context, index) {
              final code = _selected[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(
                  label: Text(
                    code,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  deleteIcon: const Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.blue,
                  ),
                  onDeleted: () {
                    setState(() => _selected.remove(code));
                  },
                  backgroundColor: Colors.blue.shade50,
                  side: BorderSide(color: Colors.blue.shade200),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'DANH SÁCH LĨNH VỰC',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return CustomCard(
      child: BlocBuilder<CatalogLookupBloc, CatalogLookupState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CustomCircularProgressScreen());
          }

          if (state.error != null) {
            return ErrorRetryWidget(
              error: state.error!,
              onRetry: () {
                context.lookupBloc.add(
                  const CatalogLookupEvent.getDomainsRef(),
                );
              },
            );
          }

          final items = state.domainsRef.where((e) {
            return e.name.toLowerCase().contains(_keyword) ||
                e.code.toLowerCase().contains(_keyword);
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final domain = items[index];
              final checked = _selected.contains(domain.code);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  title: Text(
                    domain.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(domain.code),
                  trailing: Icon(
                    checked ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: checked ? Colors.blue : Colors.grey,
                  ),
                  onTap: () => _toggle(domain.code),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFooter() {
    return SafeArea(
      child: CustomButton(
        colorBackground: Colors.blue,
        onTap: () {
          if (_selected == widget.fields) {
            context.pop();
          } else {
            context.pop(_selected);
          }
        },
        textButton: Text(
          'Xác nhận (${_selected.length})',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
