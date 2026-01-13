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
  late final CategoryGroupBloc bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc = context.read<CategoryGroupBloc>();
      bloc.add(const CategoryGroupEvent.getAll());
    });
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
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => FilterSearchWidget(),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: BlocConsumer<CategoryGroupBloc, CategoryGroupState>(
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
                      entries,
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
                            bloc.add(const CategoryGroupEvent.getAll());
                          },
                        );
                      }
                      return CategoryGroupListViewWidget(
                        categoryGroup: entries,
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        CustomFloatingActionButton(
          onPressedImport: () {
            context.pushNamed(RouterNames.importFile, extra: 2);
          },
          onPressedAdd: () {
            context.pushNamed(
              RouterNames.categoryGroupForm,
              extra: {'bloc': bloc, 'type': CategoryGroupFormType.create},
            );
          },
        ),
      ],
    );
  }
}
