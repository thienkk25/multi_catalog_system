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

  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  late final LegalDocumentBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.legalDocumentBloc;
    bloc.add(const LegalDocumentEvent.getAll());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (!bloc.state.hasMore) return;
    if (bloc.state.isLoadingMore) return;

    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      bloc.add(const LegalDocumentEvent.loadMore());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
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
                    if (state.error != null) {
                      context.notificationCubit.error(state.error!);
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
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            entries.length + (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= entries.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: CustomCircularProgressLoadMore(),
                              ),
                            );
                          }
                          final entry = entries[index];
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: LegalDocumentCard(entry: entry),
                          );
                        },
                      );
                    }
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = (constraints.maxWidth / 600)
                            .floor()
                            .clamp(1, 6);

                        final itemWidth =
                            constraints.maxWidth / crossAxisCount - 10;

                        return SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  ...entries.map(
                                    (entry) => SizedBox(
                                      width: itemWidth,
                                      child: LegalDocumentCard(entry: entry),
                                    ),
                                  ),
                                ],
                              ),

                              if (state.isLoadingMore)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: CustomCircularProgressLoadMore(),
                                ),
                            ],
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
