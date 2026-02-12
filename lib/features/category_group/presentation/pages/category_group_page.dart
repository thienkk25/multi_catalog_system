import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/category_group/presentation/presentation.dart';

class CategoryGroupPage extends StatefulWidget {
  const CategoryGroupPage({super.key});

  @override
  State<CategoryGroupPage> createState() => _CategoryGroupPageState();
}

class _CategoryGroupPageState extends State<CategoryGroupPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late final CategoryGroupBloc bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc = context.groupBloc;
      bloc.add(const CategoryGroupEvent.getAll());
    });
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
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  Expanded(
                    child: CustomInput(
                      hintText: 'Tìm kiếm theo mã, tên...',
                      suffixIcon: Icon(Icons.search),
                      controller: _searchController,
                      onChanged: (value) {
                        final search = value.trim();
                        if (_debounce?.isActive ?? false) {
                          _debounce?.cancel();
                        }
                        _debounce = Timer(
                          const Duration(milliseconds: 500),
                          () {
                            if (search.isEmpty) {
                              bloc.add(const CategoryGroupEvent.getAll());
                            } else {
                              bloc.add(
                                CategoryGroupEvent.getAll(search: search),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => CategoryGroupFilterSearchWidget(),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: BlocConsumer<CategoryGroupBloc, CategoryGroupState>(
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
                          bloc.add(const CategoryGroupEvent.getAll());
                        },
                      );
                    }
                    final entries = state.entries;
                    if (entries.isEmpty) {
                      return const Center(child: Text('Không có dữ liệu'));
                    }
                    if (ScreenSize.of(context).isMobile ||
                        ScreenSize.of(context).isTablet) {
                      return ListView.separated(
                        itemCount: entries.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          return CategoryGroupCard(entry: entry);
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
                                child: CategoryGroupCard(entry: entry),
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
          onPressedImport: () {
            context.goNamed(RouterNames.importFile, extra: 2);
          },
          onPressedAdd: () {
            context.goNamed(RouterNames.categoryGroupForm);
          },
        ),
      ],
    );
  }
}
