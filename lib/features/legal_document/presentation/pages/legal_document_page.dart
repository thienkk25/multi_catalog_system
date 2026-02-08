import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/presentation.dart';

class LegalDocumentPage extends StatefulWidget {
  const LegalDocumentPage({super.key});

  @override
  State<LegalDocumentPage> createState() => _LegalDocumentPageState();
}

class _LegalDocumentPageState extends State<LegalDocumentPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  late final LegalDocumentBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<LegalDocumentBloc>();
    bloc.add(const LegalDocumentEvent.getAll());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 10,
            children: [
              CustomInput(
                hintText: 'Tìm kiếm văn bản...',
                suffixIcon: Icon(Icons.search),
                onChanged: (value) {
                  final search = value.trim();
                  if (_debounce?.isActive ?? false) {
                    _debounce?.cancel();
                  }
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    if (search.isEmpty) {
                      bloc.add(const LegalDocumentEvent.getAll());
                    } else {
                      bloc.add(LegalDocumentEvent.getAll(search: search));
                    }
                  });
                },
              ),
              Expanded(
                child: BlocConsumer<LegalDocumentBloc, LegalDocumentState>(
                  listener: (context, state) {
                    if (state.successMessage != null) {
                      context.read<NotificationCubit>().success(
                        state.successMessage!,
                      );
                    }
                  },
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
                          bloc.add(const LegalDocumentEvent.getAll());
                        },
                      );
                    }

                    final entries = state.entries;
                    if (entries.isEmpty) {
                      return const Center(child: Text('Không có văn bản nào'));
                    }
                    return ListView.separated(
                      itemCount: entries.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return GestureDetector(
                          onTap: () {
                            context.goNamed(
                              RouterNames.legalDocumentDetail,
                              pathParameters: {'id': ?entry.id},
                            );
                          },
                          child: LegalDocumentCard(entry: entry),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        CustomFloatingActionButton(
          permission: ['admin'],
          onPressedImport: () {},
          onPressedAdd: () {
            context.goNamed(
              RouterNames.legalDocumentForm,
              extra: {'bloc': bloc},
            );
          },
        ),
      ],
    );
  }
}
