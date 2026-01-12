import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  late final ApiKeyBloc bloc;

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
                    if (state.createdEntry != null) {
                      _showSuccessDialog(context, state.createdEntry!.key!);
                    }
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
                      createdEntry,
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

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sao chép thành công'),
        backgroundColor: Colors.green,
      ),
    );
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

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SelectableText(
                    apiKey,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                ),

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
