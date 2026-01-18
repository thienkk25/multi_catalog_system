import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/core.dart';
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
                suffixIcon: Icon(Icons.search),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return UserManagementCard();
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemCount: 10,
                ),
              ),
            ],
          ),
        ),
        CustomFloatingActionButton(onPressedImport: () {}, onPressedAdd: () {}),
      ],
    );
  }
}
