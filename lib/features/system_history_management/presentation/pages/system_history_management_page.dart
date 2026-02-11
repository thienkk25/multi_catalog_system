import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/error_retry_widget.dart';
import 'package:multi_catalog_system/features/system_history_management/presentation/presentation.dart';

class SystemHistoryManagementPage extends StatefulWidget {
  const SystemHistoryManagementPage({super.key});

  @override
  State<SystemHistoryManagementPage> createState() =>
      _SystemHistoryManagementPageState();
}

class _SystemHistoryManagementPageState
    extends State<SystemHistoryManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late final SystemHistoryBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.systemHistoryBloc;
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
                    if (state.isLoading) {
                      return const Center(
                        child: CustomCircularProgressScreen(),
                      );
                    }

                    if (state.error != null) {
                      return ErrorRetryWidget(
                        error: state.error!,
                        onRetry: () {
                          bloc.add(const SystemHistoryEvent.getAll());
                        },
                      );
                    }

                    if (state.entries.isEmpty) {
                      return const Center(child: Text('Không có dữ liệu'));
                    }

                    final entries = state.entries;

                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: entries.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => context.goNamed(
                          RouterNames.systemHistoryManagementDetail,
                          pathParameters: {'id': entries[index].id.toString()},
                        ),
                        child: SystemHistoryManagementCard(log: entries[index]),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                    );
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
