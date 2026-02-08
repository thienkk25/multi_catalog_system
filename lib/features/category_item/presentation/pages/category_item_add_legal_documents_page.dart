import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_bloc.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_event.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_state.dart';

class CategoryItemAddLegalDocumentsPage extends StatefulWidget {
  final List<LegalDocumentEntry>? legalDocuments;

  const CategoryItemAddLegalDocumentsPage({super.key, this.legalDocuments});

  @override
  State<CategoryItemAddLegalDocumentsPage> createState() =>
      _CategoryItemAddLegalDocumentsPageState();
}

class _CategoryItemAddLegalDocumentsPageState
    extends State<CategoryItemAddLegalDocumentsPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late List<LegalDocumentEntry> _legalDocuments;

  final GlobalKey _bottomBarKey = GlobalKey();
  double _bottomBarHeight = 0;

  @override
  void initState() {
    super.initState();
    context.read<LegalDocumentBloc>().add(
      const LegalDocumentEvent.getAllHasFile(),
    );
    _legalDocuments = widget.legalDocuments ?? [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _bottomBarKey.currentContext;
      if (context != null) {
        final height = context.size?.height ?? 0;
        if (height != _bottomBarHeight) {
          setState(() => _bottomBarHeight = height);
        }
      }
    });
  }

  @override
  void dispose() {
    _bottomBarKey.currentState?.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách văn bản pháp lý'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text(
              'Hủy',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  automaticallyImplyActions: false,
                  backgroundColor: Color(0xFFF5F7FA),
                  title: CustomInput(
                    hintText: 'Tìm kiếm theo tên, mã...',
                    suffixIcon: Icon(Icons.search),
                    onChanged: (value) {
                      final search = value.trim();
                      if (_debounce?.isActive ?? false) {
                        _debounce?.cancel();
                      }
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        if (search.isEmpty) {
                          context.read<LegalDocumentBloc>().add(
                            const LegalDocumentEvent.getAllHasFile(),
                          );
                        } else {
                          context.read<LegalDocumentBloc>().add(
                            LegalDocumentEvent.getAllHasFile(search: search),
                          );
                        }
                      });
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(10.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      BlocBuilder<LegalDocumentBloc, LegalDocumentState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                              child: CustomCircularProgressScreen(),
                            );
                          }
                          if (state.error != null) {
                            return ErrorRetryWidget(
                              error: state.error!,
                              onRetry: () {
                                context.read<LegalDocumentBloc>().add(
                                  const LegalDocumentEvent.getAllHasFile(),
                                );
                              },
                            );
                          }

                          if (state.entries.isEmpty) {
                            return const Center(
                              child: Text('Không có dữ liệu'),
                            );
                          }
                          final entries = state.entries;

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: entries.length,
                            itemBuilder: (_, index) {
                              final entry = entries[index];

                              return BlocSelector<
                                LegalDocumentBloc,
                                LegalDocumentState,
                                bool
                              >(
                                selector: (state) =>
                                    state.selectedIds.contains(entry.id),
                                builder: (_, isSelected) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    child: _LegalDocumentCard(
                                      entry: entry,
                                      isSelected: isSelected,
                                      onChanged: (_) {
                                        context.read<LegalDocumentBloc>().add(
                                          LegalDocumentEvent.toggleSelect(
                                            entry.id!,
                                          ),
                                        );
                                        if (!isSelected) {
                                          _legalDocuments.add(entry);
                                        } else {
                                          _legalDocuments.remove(entry);
                                        }
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(bottom: _bottomBarHeight),
                ),
              ],
            ),
            BlocSelector<LegalDocumentBloc, LegalDocumentState, int>(
              key: _bottomBarKey,
              selector: (state) => state.selectedIds.length,
              builder: (_, countSelected) {
                return _BottomFormActions(
                  countSelected: countSelected,
                  onSave: () {
                    context.pop(_legalDocuments);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LegalDocumentCard extends StatelessWidget {
  final LegalDocumentEntry entry;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  const _LegalDocumentCard({
    required this.entry,
    required this.isSelected,
    required this.onChanged,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _metaItem(
    BuildContext context, {
    required IconData icon,
    required String? text,
  }) {
    if (text == null || text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey.shade700)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => onChanged(!isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withValues(alpha: .06) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title ?? '--',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: isSelected,
                  activeColor: Colors.blue,
                  shape: const CircleBorder(),
                  onChanged: (v) => onChanged(v ?? false),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _metaItem(context, icon: Icons.tag, text: entry.code),
                _metaItem(context, icon: Icons.category, text: entry.type),
                if (entry.effectiveDate != null)
                  _metaItem(
                    context,
                    icon: Icons.event,
                    text: 'Hiệu lực: ${_formatDate(entry.effectiveDate!)}',
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade300),
              ),
              child: Row(
                children: [
                  FileIconWidget(fileName: entry.fileName ?? ''),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.fileName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomFormActions extends StatelessWidget {
  final int countSelected;
  final VoidCallback onSave;
  const _BottomFormActions({required this.onSave, required this.countSelected});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: .5),
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: CustomButton(
          onTap: onSave,
          colorBackground: Colors.blue,
          textButton: Text(
            'Xác nhận ($countSelected)',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight(600),
            ),
          ),
        ),
      ),
    );
  }
}
