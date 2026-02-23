import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/responsive/screen_size.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/widgets/buttom_up_widget.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/custom_dropdown_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_floating_action_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/error_retry_widget.dart';
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
  late ValueNotifier<bool> _showUpButton;
  late final DomainManagementBloc bloc;

  @override
  void initState() {
    super.initState();

    _showUpButton = ValueNotifier(false);

    bloc = context.domainManagementBloc;
    bloc.add(const DomainManagementEvent.getAll(sortBy: 'code', sort: 'asc'));

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final shouldShow = _scrollController.offset > 300;

    if (_showUpButton.value != shouldShow) {
      _showUpButton.value = shouldShow;
    }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!ScreenSize.of(context).isMobile)
                const Text(
                  'Lĩnh vực',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              Expanded(
                child: BlocConsumer<DomainManagementBloc, DomainManagementState>(
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
                    return CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
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
                                  _debounce = Timer(
                                    const Duration(milliseconds: 500),
                                    () {
                                      if (search.isEmpty) {
                                        bloc.add(
                                          const DomainManagementEvent.getAll(
                                            sortBy: 'code',
                                            sort: 'asc',
                                          ),
                                        );
                                      } else {
                                        bloc.add(
                                          DomainManagementEvent.getAll(
                                            search: search,
                                            sortBy: bloc.state.sortBy,
                                            sort: bloc.state.sort,
                                            filter: bloc.state.filter,
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Text('Sắp xếp theo'),
                                  SizedBox(
                                    width: 150,
                                    child: CustomDropdownButton(
                                      items: [
                                        DropdownMenuItem(
                                          value: 'code',
                                          child: Text('Mã lĩnh vực'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'name',
                                          child: Text('Tên lĩnh vực'),
                                        ),
                                      ],
                                      value: bloc.state.sortBy ?? 'code',
                                      onChanged: (value) {
                                        if (value == null) return;
                                        bloc.add(
                                          DomainManagementEvent.getAll(
                                            search: bloc.state.search,
                                            sortBy: value,
                                            sort: bloc.state.sort,
                                            filter: bloc.state.filter,
                                          ),
                                        ); // bloc.add(DomainManagementEvent.sortBy(value));
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: CustomDropdownButton(
                                      value: bloc.state.sort ?? 'asc',
                                      items: [
                                        DropdownMenuItem(
                                          value: 'asc',
                                          child: Text('Tăng dần'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'desc',
                                          child: Text('Giảm dần'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        if (value == null) return;
                                        bloc.add(
                                          DomainManagementEvent.getAll(
                                            search: bloc.state.search,
                                            sortBy: bloc.state.sortBy,
                                            sort: value,
                                            filter: bloc.state.filter,
                                          ),
                                        ); // bloc.add(DomainManagementEvent.sort(value));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SliverPadding(padding: EdgeInsets.only(top: 10)),
                        SliverGrid.builder(
                          itemCount: entries.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                          itemBuilder: (context, index) {
                            final entry = entries[index];

                            return GestureDetector(
                              onTap: () => context.goNamed(
                                RouterNames.domainDetail,
                                pathParameters: {'id': entry.id!},
                              ),
                              child: DomainManagementCard(entry: entry),
                            );
                          },
                        ),

                        if (state.isLoadingMore)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: CustomCircularProgressLoadMore(),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
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
