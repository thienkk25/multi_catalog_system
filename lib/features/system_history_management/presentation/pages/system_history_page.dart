import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        spacing: 10,
        children: [
          CustomInput(hintText: 'Tìm kiếm...', suffixIcon: Icon(Icons.search)),
          Expanded(
            child: BlocBuilder<SystemHistoryBloc, SystemHistoryState>(
              builder: (context, state) {
                return state.when((isLoading, error, entities) {
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
                    itemCount: entities.length,
                    itemBuilder: (context, index) =>
                        SystemHistoryCard(log: entities[index]),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
