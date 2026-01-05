import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/bloc/api_key_bloc.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/bloc/api_key_event.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/bloc/api_key_state.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/pages/api_key_management_form_page.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/widgets/api_key_management_card.dart';

class ApiKeyManagementPage extends StatefulWidget {
  const ApiKeyManagementPage({super.key});

  @override
  State<ApiKeyManagementPage> createState() => _ApiKeyManagementPageState();
}

class _ApiKeyManagementPageState extends State<ApiKeyManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late ApiKeyBloc bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc = context.read<ApiKeyBloc>();
      bloc.add(const ApiKeyEvent.getAll());
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
              CustomInput(
                controller: _searchController,
                hintText: 'Tìm kiếm...',
                suffixIcon: Icon(Icons.search),
                onChanged: (value) {
                  final search = value.trim();
                  if (_debounce?.isActive ?? false) {
                    _debounce?.cancel();
                  }
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    if (search.isEmpty) {
                      bloc.add(const ApiKeyEvent.getAll());
                    } else {
                      bloc.add(ApiKeyEvent.getAll(search: search));
                    }
                  });
                },
              ),
              Expanded(
                child: BlocConsumer<ApiKeyBloc, ApiKeyState>(
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
                            bloc.add(const ApiKeyEvent.getAll());
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
                              context.pushNamed(
                                RouterNames.apiKeyDetail,
                                pathParameters: {'id': ?entry.id},
                                extra: entry,
                              );
                            },
                            child: ApiKeyManagementCard(entry: entry),
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
        CustomFloatingActionButton(
          onPressedImport: () {},
          onPressedAdd: () {
            context.pushNamed(
              RouterNames.apiKeyForm,
              extra: {
                'bloc': bloc,
                'type': ApiKeyManagementFormPageType.create,
              },
            );
          },
        ),
      ],
    );
  }
}
