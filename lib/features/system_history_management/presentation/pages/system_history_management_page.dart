import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/responsive/screen_size.dart';
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
    extends State<SystemHistoryManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  late final SystemHistoryBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.systemHistoryBloc;
    bloc.add(const SystemHistoryEvent.getAll());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (!bloc.state.hasMore) return;
    if (bloc.state.isLoadingMore) return;

    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      bloc.add(const SystemHistoryEvent.loadMore());
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
    return SafeArea(
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
                    return const Center(child: CustomCircularProgressScreen());
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
                  if (ScreenSize.of(context).isMobile ||
                      ScreenSize.of(context).isTablet) {
                    return ListView.separated(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: entries.length + (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= entries.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CustomCircularProgressLoadMore(),
                            ),
                          );
                        }
                        final entry = entries[index];
                        return SystemHistoryManagementCard(log: entry);
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                    );
                  }
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = (constraints.maxWidth / 600)
                          .floor()
                          .clamp(1, 6);

                      final itemWidth =
                          constraints.maxWidth / crossAxisCount - 10;

                      return SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                ...entries.map(
                                  (entry) => SizedBox(
                                    width: itemWidth,
                                    child: SystemHistoryManagementCard(
                                      log: entry,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (state.isLoadingMore)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: CustomCircularProgressLoadMore(),
                              ),
                          ],
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
    );
  }
}
