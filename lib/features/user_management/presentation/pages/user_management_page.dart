import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_bloc.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_event.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_state.dart';
import 'package:multi_catalog_system/features/user_management/presentation/widgets/user_management_card.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late final UserManagementBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<UserManagementBloc>();
    bloc.add(const UserManagementEvent.getAll());
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
                hintText: 'Tìm kiếm...',
                suffixIcon: const Icon(Icons.search),
                onChanged: (value) {
                  final search = value.trim();
                  if (_debounce?.isActive ?? false) {
                    _debounce?.cancel();
                  }
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    if (search.isEmpty) {
                      bloc.add(const UserManagementEvent.getAll());
                    } else {
                      bloc.add(UserManagementEvent.getAll(search: search));
                    }
                  });
                },
              ),
              Expanded(
                child: BlocConsumer<UserManagementBloc, UserManagementState>(
                  listener: (context, state) {
                    if (state.successMessage != null) {
                      context.read<NotificationCubit>().success(
                        state.successMessage!,
                      );
                    }
                    if (state.error != null) {
                      context.read<NotificationCubit>().error(state.error!);
                    }
                  },
                  builder: (context, state) =>
                      state.when((isLoading, entries, error, successMessage) {
                        if (isLoading) {
                          return Center(child: CustomCircularProgressScreen());
                        }
                        if (error != null) {
                          return ErrorRetryWidget(
                            error: error,
                            onRetry: () {
                              bloc.add(const UserManagementEvent.getAll());
                            },
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final entry = entries[index];
                            return UserManagementCard(entry: entry);
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10),
                          itemCount: entries.length,
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
        CustomFloatingActionButton(
          onPressedImport: () {},
          onPressedAdd: () {
            context.pushNamed(
              RouterNames.userManagementForm,
              extra: {'bloc': bloc},
            );
          },
        ),
      ],
    );
  }
}
