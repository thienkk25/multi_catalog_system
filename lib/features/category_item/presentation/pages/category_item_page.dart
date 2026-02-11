import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/responsive/screen_size.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/custom_floating_action_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/error_retry_widget.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_event.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_state.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_state.dart';
import 'package:multi_catalog_system/features/category_item/presentation/pages/category_item_form_page.dart';
import 'package:multi_catalog_system/features/category_item/presentation/widgets/category_item_card.dart';

class CategoryItemPage extends StatefulWidget {
  const CategoryItemPage({super.key});

  @override
  State<CategoryItemPage> createState() => _CategoryItemPageState();
}

class _CategoryItemPageState extends State<CategoryItemPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.itemBloc.add(const CategoryItemEvent.getAll());
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
    return MultiBlocListener(
      listeners: [
        BlocListener<CategoryItemBloc, CategoryItemState>(
          listener: (context, state) {
            if (state.error != null) {
              context.notificationCubit.error(state.error!);
            }
            if (state.successMessage != null) {
              context.notificationCubit.success(state.successMessage!);
            }
          },
        ),
        BlocListener<CategoryItemVersionBloc, CategoryItemVersionState>(
          listener: (context, state) {
            if (state.error != null) {
              context.notificationCubit.error(state.error!);
            }
            if (state.successMessage != null) {
              context.notificationCubit.success(state.successMessage!);
            }
          },
        ),
      ],
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
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
                        context.itemBloc.add(const CategoryItemEvent.getAll());
                      } else {
                        context.itemBloc.add(
                          CategoryItemEvent.getAll(search: search),
                        );
                      }
                    });
                  },
                ),
                Expanded(
                  child: BlocBuilder<CategoryItemBloc, CategoryItemState>(
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
                            context.itemBloc.add(
                              const CategoryItemEvent.getAll(),
                            );
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
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final entry = entries[index];
                            return CategoryItemCard(entry: entry);
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
                                      constraints.maxWidth / crossAxisCount -
                                      10,
                                  child: CategoryItemCard(entry: entry),
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
              context.goNamed(RouterNames.importFile, extra: 3);
            },
            onPressedAdd: () {
              context.goNamed(
                RouterNames.categoryItemForm,
                queryParameters: {'mode': CategoryItemFormMode.create.name},
              );
            },
          ),
        ],
      ),
    );
  }
}
