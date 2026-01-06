import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/category_item/presentation/presentation.dart';

import 'category_item_detail_page.dart';

class CategoryItemPage extends StatefulWidget {
  const CategoryItemPage({super.key});

  @override
  State<CategoryItemPage> createState() => _CategoryItemPageState();
}

class _CategoryItemPageState extends State<CategoryItemPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  late final CategoryItemBloc bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc = context.read<CategoryItemBloc>();
      bloc.add(const CategoryItemEvent.getAll());
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
    return Stack(
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
                      bloc.add(const CategoryItemEvent.getAll());
                    } else {
                      bloc.add(CategoryItemEvent.getAll(search: search));
                    }
                  });
                },
              ),
              Expanded(
                child: BlocConsumer<CategoryItemBloc, CategoryItemState>(
                  listener: (context, state) {
                    if (state.successMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.successMessage!),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return state.when((
                      isLoading,
                      entities,
                      error,
                      successMessage,
                    ) {
                      if (isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (error != null) {
                        return ErrorRetryWidget(
                          error: error,
                          onRetry: () {
                            bloc.add(const CategoryItemEvent.getAll());
                          },
                        );
                      }
                      return ListView.separated(
                        itemCount: entities.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final entry = entities[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CategoryItemDetailPage(entry: entry),
                                ),
                              );
                            },
                            child: CategoryItemCard(entry: entry),
                          );
                        },
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        CustomFloatingActionButton(onPressedImport: () {}, onPressedAdd: () {}),
      ],
    );
  }
}
