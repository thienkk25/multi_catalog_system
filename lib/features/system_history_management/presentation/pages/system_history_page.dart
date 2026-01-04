import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/error_retry_widget.dart';
import 'package:multi_catalog_system/features/system_history_management/presentation/bloc/system_history_bloc.dart';
import 'package:multi_catalog_system/features/system_history_management/presentation/bloc/system_history_event.dart';
import 'package:multi_catalog_system/features/system_history_management/presentation/bloc/system_history_state.dart';
import 'package:multi_catalog_system/features/system_history_management/presentation/widgets/system_history_card.dart';

class SystemHistoryPage extends StatefulWidget {
  const SystemHistoryPage({super.key});

  @override
  State<SystemHistoryPage> createState() => _SystemHistoryPageState();
}

class _SystemHistoryPageState extends State<SystemHistoryPage> {
  late final SystemHistoryBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = context.read<SystemHistoryBloc>();
    bloc.add(const SystemHistoryEvent.getAll());
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
        child: BlocBuilder<SystemHistoryBloc, SystemHistoryState>(
          builder: (context, state) {
            return state.when((isLoading, error, entities) {
              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (error != null) {
                return Center(
                  child: ErrorRetryWidget(
                    error: error,
                    onRetry: () {
                      bloc.add(const SystemHistoryEvent.getAll());
                    },
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  spacing: 10,
                  children: [
                    CustomInput(
                      hintText: 'Tìm kiếm...',
                      suffixIcon: const Icon(Icons.search),
                    ),
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: entities.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () => context.pushNamed(
                            RouterNames.systemHistoryManagementDetail,
                            pathParameters: {
                              'id': entities[index].id.toString(),
                            },
                            extra: entities[index],
                          ),
                          child: SystemHistoryCard(log: entities[index]),
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                      ),
                    ),
                  ],
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
