import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/presentation.dart';

class DomainManagementPage extends StatefulWidget {
  const DomainManagementPage({super.key});

  @override
  State<DomainManagementPage> createState() => _DomainManagementPageState();
}

class _DomainManagementPageState extends State<DomainManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  final ScrollController _scrollController = ScrollController();
  late final DomainManagementBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = context.domainManagementBloc;
    bloc.add(const DomainManagementEvent.getAll());

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (!bloc.state.hasMore) return;
    if (bloc.state.isLoadingMore) return;

    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      bloc.add(const DomainManagementEvent.loadMore());
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
                controller: _searchController,
                hintText: 'Tìm kiếm lĩnh vực',
                suffixIcon: Icon(Icons.search),
                onChanged: (value) {
                  final search = value.trim();
                  if (_debounce?.isActive ?? false) {
                    _debounce?.cancel();
                  }
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    if (search.isEmpty) {
                      bloc.add(const DomainManagementEvent.getAll());
                    } else {
                      bloc.add(DomainManagementEvent.getAll(search: search));
                    }
                  });
                },
              ),
              Expanded(
                child:
                    BlocConsumer<DomainManagementBloc, DomainManagementState>(
                      listener: (context, state) {
                        if (state.successMessage != null) {
                          context.notificationCubit.success(
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
                              bloc.add(const DomainManagementEvent.getAll());
                            },
                          );
                        }
                        final entries = state.entries;
                        if (entries.isEmpty) {
                          return const Center(child: Text('Không có dữ liệu'));
                        }
                        final crossAxisCount = ScreenSize.of(context).isMobile
                            ? 2
                            : ScreenSize.of(context).isTablet
                            ? 3
                            : 4;
                        return GridView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount:
                              entries.length + (state.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == entries.length) {
                              return const Center(
                                child: CustomCircularProgressLoadMore(),
                              );
                            }

                            final entry = entries[index];
                            return GestureDetector(
                              onTap: () => context.goNamed(
                                RouterNames.domainDetail,
                                pathParameters: {'id': entry.id!},
                              ),
                              child: DomainManagementCard(entry: entry),
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
          onPressedImport: () {
            context.goNamed(RouterNames.importFile, extra: 1);
          },
          onPressedAdd: () {
            context.goNamed(
              RouterNames.domainForm,
              queryParameters: {'mode': 'create'},
            );
          },
        ),
      ],
    );
  }
}
