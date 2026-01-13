import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/error_retry_widget.dart';
import 'package:multi_catalog_system/features/system_history_management/presentation/presentation.dart';

class SystemHistoryPage extends StatefulWidget {
  const SystemHistoryPage({super.key});

  @override
  State<SystemHistoryPage> createState() => _SystemHistoryPageState();
}

class _SystemHistoryPageState extends State<SystemHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late final SystemHistoryBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<SystemHistoryBloc>();
    bloc.add(const SystemHistoryEvent.getAll());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nhật kí hệ thống',
          style: TextStyle(fontWeight: FontWeight(600), fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 10,
            children: [
              CustomInput(
                hintText: 'Tìm kiếm...',
                suffixIcon: const Icon(Icons.search),
                onChanged: (value) {
                  final search = value.trim();
                  if (_debounce?.isActive ?? false) {
                    _debounce?.cancel();
                  }
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    if (search.isEmpty) {
                      bloc.add(const SystemHistoryEvent.getAll());
                    } else {
                      bloc.add(SystemHistoryEvent.getAll(search: search));
                    }
                  });
                },
              ),
              Expanded(
                child: BlocBuilder<SystemHistoryBloc, SystemHistoryState>(
                  builder: (context, state) {
                    return state.when((isLoading, error, entries) {
                      if (isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (error != null) {
                        return ErrorRetryWidget(
                          error: error,
                          onRetry: () {
                            bloc.add(const SystemHistoryEvent.getAll());
                          },
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: entries.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () => context.pushNamed(
                            RouterNames.systemHistoryManagementDetail,
                            pathParameters: {
                              'id': entries[index].id.toString(),
                            },
                            extra: entries[index],
                          ),
                          child: SystemHistoryCard(log: entries[index]),
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
