import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/error_retry_widget.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_bloc.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_event.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_state.dart';

class UserManagementAddDomainsPage extends StatefulWidget {
  final List<DomainRefEntry> fields;

  const UserManagementAddDomainsPage({super.key, required this.fields});

  @override
  State<UserManagementAddDomainsPage> createState() =>
      _UserManagementAddDomainsPageState();
}

class _UserManagementAddDomainsPageState
    extends State<UserManagementAddDomainsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _chipScrollController = ScrollController();

  late List<DomainRefEntry> _selected;
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.fields);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _chipScrollController.dispose();
    super.dispose();
  }

  bool _isAllSelected(List<DomainRefEntry> entries) {
    return entries.isNotEmpty && _selected.length == entries.length;
  }

  void _toggleSelectAll(List<DomainRefEntry> entries) {
    setState(() {
      _selected = _isAllSelected(entries) ? [] : List.from(entries);
    });
  }

  void _toggle(DomainRefEntry entry) {
    setState(() {
      _selected.contains(entry)
          ? _selected.remove(entry)
          : _selected.add(entry);
    });
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
              final domains = state.domainsRef;
              final isAll = _isAllSelected(domains);

              return TextButton(
                onPressed: domains.isEmpty
                    ? null
                    : () => _toggleSelectAll(domains),
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
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearch(),
              const SizedBox(height: 8),
              _buildSelectedChips(),
              _buildLabel(),
              const SizedBox(height: 8),
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
      suffixIcon: const Icon(Icons.search),
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
            itemCount: _selected.length,
            itemBuilder: (context, index) {
              final domain = _selected[index];

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  label: Text(
                    domain.name,
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
                    setState(() => _selected.remove(domain));
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
                context.read<CatalogLookupBloc>().add(
                  const CatalogLookupEvent.getDomainsRef(),
                );
              },
            );
          }

          final items = state.domainsRef.where((e) {
            return e.name.toLowerCase().contains(_keyword) ||
                e.code.toLowerCase().contains(_keyword);
          }).toList();

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final domain = items[index];
              final checked = _selected.contains(domain);

              return ListTile(
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
                onTap: () => _toggle(domain),
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
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
