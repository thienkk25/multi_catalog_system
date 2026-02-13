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
    bloc = context.legalDocumentBloc;
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
                      context.notificationCubit.success(state.successMessage!);
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
                    if (ScreenSize.of(context).isMobile ||
                        ScreenSize.of(context).isTablet) {
                      return ListView.separated(
                        itemCount: entries.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          return LegalDocumentCard(entry: entry);
                        },
                      );
                    }
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = (constraints.maxWidth / 600)
                            .floor();

                        return SingleChildScrollView(
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: entries.map((entry) {
                              return SizedBox(
                                width:
                                    constraints.maxWidth / crossAxisCount - 10,
                                child: LegalDocumentCard(entry: entry),
                              );
                            }).toList(),
                          ),
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
              queryParameters: {'mode': 'create'},
            );
          },
        ),
      ],
    );
  }
}
