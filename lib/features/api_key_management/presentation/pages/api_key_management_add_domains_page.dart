import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/widgets/buttom_up_widget.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/error_retry_widget.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_lookup_bloc.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_lookup_event.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_lookup_state.dart';

class ApiKeyManagementAddDomainsPage extends StatefulWidget {
  final List<DomainRefEntry> fields;

  const ApiKeyManagementAddDomainsPage({super.key, required this.fields});

  @override
  State<ApiKeyManagementAddDomainsPage> createState() =>
      _ApiKeyManagementAddDomainsPageState();
}

class _ApiKeyManagementAddDomainsPageState
    extends State<ApiKeyManagementAddDomainsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _chipScrollController = ScrollController();

  late ValueNotifier<bool> _showUpButton;
  late final DomainLookupBloc _bloc;

  late List<DomainRefEntry> _selected;
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _bloc = context.domainLookupBloc;
    _bloc.add(const DomainLookupEvent.lookup());
    _showUpButton = ValueNotifier(false);
    _scrollController.addListener(_onScroll);
    _selected = List.from(widget.fields);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final shouldShow = _scrollController.offset > 300;

    if (_showUpButton.value != shouldShow) {
      _showUpButton.value = shouldShow;
    }

    if (!_bloc.state.hasMore) return;
    if (_bloc.state.isLoadingMore) return;

    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      _bloc.add(const DomainLookupEvent.loadMore());
    }
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
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _chipScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeder(),
                const SizedBox(height: 8),
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
          ValueListenableBuilder<bool>(
            valueListenable: _showUpButton,
            builder: (context, show, child) {
              return ButtomUpWidget(
                scrollController: _scrollController,
                show: show,
              );
            },
          ),
        ],
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
    if (_selected.isEmpty) return const SizedBox.shrink();

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
                    domain.name!,
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
      child: BlocBuilder<DomainLookupBloc, DomainLookupState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CustomCircularProgressScreen());
          }

          if (state.error != null) {
            return ErrorRetryWidget(
              error: state.error!,
              onRetry: () {
                context.domainLookupBloc.add(const DomainLookupEvent.lookup());
              },
            );
          }

          if (state.entries.isEmpty) {
            return const Center(child: Text('Không có dữ liệu'));
          }

          final items = state.entries.where((e) {
            return e.name!.toLowerCase().contains(_keyword) ||
                e.code!.toLowerCase().contains(_keyword);
          }).toList();

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverList.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final domain = items[index];
                  final checked = _selected.contains(domain);

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: checked
                          ? Colors.blue.shade50
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        domain.name!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(domain.code!),
                      trailing: Icon(
                        checked
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: checked ? Colors.blue : Colors.grey,
                      ),
                      onTap: () => _toggle(domain),
                    ),
                  );
                },
              ),
              if (state.isLoadingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CustomCircularProgressLoadMore()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFooter() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          spacing: 10,
          children: [
            Expanded(
              child: CustomButton(
                colorBackground: Colors.transparent,
                colorBorder: Colors.blue.withValues(alpha: .5),
                onTap: () {
                  context.pop();
                },
                textButton: Text(
                  'Hủy',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${_selected.length} Lĩnh vực đang chọn',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        BlocBuilder<DomainLookupBloc, DomainLookupState>(
          builder: (context, state) {
            final domains = state.entries;
            final isAll = _isAllSelected(domains);

            return TextButton(
              onPressed: domains.isEmpty
                  ? null
                  : () => _toggleSelectAll(domains),
              child: Text(
                isAll ? 'Bỏ chọn tất cả' : 'Chọn tất cả',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
