import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/bloc/api_key_bloc.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/bloc/api_key_event.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/bloc/api_key_state.dart';
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
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  late final ApiKeyBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.apiKeyBloc;
    bloc.add(const ApiKeyEvent.getAll());

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (!bloc.state.hasMore) return;
    if (bloc.state.isLoadingMore) return;

    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      bloc.add(const ApiKeyEvent.loadMore());
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
                    if (state.createdEntry != null) {
                      _showSuccessDialog(context, state.createdEntry!.key!);
                    }
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
                          bloc.add(const ApiKeyEvent.getAll());
                        },
                      );
                    }
                    if (state.entries.isEmpty) {
                      return Center(child: Text('Không có dữ liệu'));
                    }

                    final entries = state.entries;
                    if (ScreenSize.of(context).isMobile ||
                        ScreenSize.of(context).isTablet) {
                      return ListView.separated(
                        controller: _scrollController,
                        itemCount:
                            entries.length + (state.isLoadingMore ? 1 : 0),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
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
                          return ApiKeyManagementCard(entry: entry);
                        },
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
                                      child: ApiKeyManagementCard(entry: entry),
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
        CustomFloatingActionButton(
          onPressedImport: () {},
          onPressedAdd: () {
            context.goNamed(
              RouterNames.apiKeyForm,
              queryParameters: {'mode': 'create'},
            );
          },
        ),
      ],
    );
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    context.notificationCubit.success('Sao chép API Key thành công');
  }

  void _showSuccessDialog(BuildContext context, String apiKey) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: .1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 36,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Tạo API Key thành công',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Vui lòng sao chép và lưu trữ API Key.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 16),

                CodeBlockWidget(text: apiKey),

                const SizedBox(height: 20),

                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: CustomButton(
                        colorBackground: Colors.white,
                        textButton: Text('Đóng'),
                        onTap: () => context.pop(),
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        colorBackground: Colors.blue,
                        textButton: const Text(
                          'Sao chép',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () => _copyToClipboard(context, apiKey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
