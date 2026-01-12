import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entries/legal_document_entry.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<LegalDocumentBloc>().add(
      const LegalDocumentEvent.getAllHasFile(),
    );
    _legalDocuments = widget.legalDocuments ?? [];
  }

  @override
  void dispose() {
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
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.all(10.0),
              child: Column(
                spacing: 10,
                children: [
                  CustomInput(
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
                  Expanded(
                    child: BlocBuilder<LegalDocumentBloc, LegalDocumentState>(
                      builder: (context, state) => state.when((
                        isLoading,
                        entities,
                        selectedIds,
                        error,
                        successMessage,
                      ) {
                        if (isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (error != null) {
                          return ErrorRetryWidget(
                            error: error,
                            onRetry: () {
                              context.read<LegalDocumentBloc>().add(
                                const LegalDocumentEvent.getAllHasFile(),
                              );
                            },
                          );
                        }
                        return ListView.separated(
                          itemCount: entities.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, index) {
                            final entry = entities[index];

                            return BlocSelector<
                              LegalDocumentBloc,
                              LegalDocumentState,
                              bool
                            >(
                              selector: (state) =>
                                  state.selectedIds.contains(entry.id),
                              builder: (_, isSelected) {
                                return _LegalDocumentCard(
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
                                );
                              },
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            BlocSelector<LegalDocumentBloc, LegalDocumentState, int>(
              selector: (state) => state.selectedIds.length,
              builder: (_, countSelected) {
                return _BottomFormActions(
                  countSelected: countSelected,
                  onCancel: () => context.pop(),
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

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: isSelected ? Colors.blue.withValues(alpha: .1) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Row(
            spacing: 5,
            children: [
              Expanded(
                child: Text(
                  entry.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Checkbox(
                shape: const CircleBorder(),
                value: isSelected,
                onChanged: (value) => onChanged(value ?? false),
              ),
            ],
          ),
          Text(entry.code, style: const TextStyle(color: Colors.grey)),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? Colors.blue
                    : Colors.blue.withValues(alpha: .3),
              ),
            ),
            child: Row(
              spacing: 8,
              children: [
                FileIcon(fileName: entry.fileName!),
                Expanded(
                  child: Text(
                    entry.fileName!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomFormActions extends StatelessWidget {
  final int countSelected;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  const _BottomFormActions({
    required this.onCancel,
    required this.onSave,
    required this.countSelected,
  });

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
        child: Column(
          spacing: 10,
          children: [
            CustomButton(
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
            CustomButton(
              onTap: onCancel,
              colorBackground: Colors.white,
              colorBorder: Colors.blue.withValues(alpha: .5),
              textButton: const Text(
                'Hủy',
                style: TextStyle(fontWeight: FontWeight(600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
