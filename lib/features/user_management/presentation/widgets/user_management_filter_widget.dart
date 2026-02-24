import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_dropdown_button.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_bloc.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_event.dart';

class UserManagementFilterWidget extends StatefulWidget {
  final VoidCallback onClose;
  const UserManagementFilterWidget({super.key, required this.onClose});

  @override
  State<UserManagementFilterWidget> createState() =>
      _UserManagementFilterWidgetState();
}

class _UserManagementFilterWidgetState
    extends State<UserManagementFilterWidget> {
  String? _selectedRole;
  String? _selectedStatus;
  String _sortBy = 'full_name';
  String _sort = 'asc';

  late final UserManagementBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.userManagementBloc;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              children: [
                Text(
                  'Bộ lọc',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.keyboard_double_arrow_left),
                  onPressed: () => widget.onClose(),
                ),
              ],
            ),

            CustomDropdownButton<String>(
              lable: Text('Quyền tài khoản'),
              hint: 'Quyền tài khoản',
              value: _selectedRole,
              items: const [
                DropdownMenuItem(value: null, child: Text('Tất cả')),
                DropdownMenuItem(
                  value: 'admin',
                  child: Text('Quản trị hệ thống cấp cao'),
                ),
                DropdownMenuItem(
                  value: 'approver',
                  child: Text('Chuyên viên duyệt'),
                ),
                DropdownMenuItem(
                  value: 'domainOfficer',
                  child: Text('Cán bộ chuyên môn'),
                ),
              ],
              onChanged: (value) {
                setState(() => _selectedRole = value);
              },
            ),
            CustomDropdownButton<String>(
              lable: Text('Trạng thái tài khoản'),
              hint: 'Trạng thái',
              value: _selectedStatus,
              items: const [
                DropdownMenuItem(value: null, child: Text('Tất cả')),
                DropdownMenuItem(value: 'active', child: Text('Hoạt động')),
                DropdownMenuItem(value: 'inactive', child: Text('Khóa')),
              ],
              onChanged: (value) {
                setState(() => _selectedStatus = value);
              },
            ),

            CustomDropdownButton<String>(
              lable: Text('Sắp xếp theo'),
              hint: 'Sắp xếp theo',
              value: '$_sortBy|$_sort',
              items: const [
                DropdownMenuItem(
                  value: 'full_name|asc',
                  child: Text('Họ và Tên (A → Z)'),
                ),
                DropdownMenuItem(
                  value: 'full_name|desc',
                  child: Text('Họ và Tên (Z → A)'),
                ),
                DropdownMenuItem(
                  value: 'email|asc',
                  child: Text('Email (A → Z)'),
                ),
                DropdownMenuItem(
                  value: 'email|desc',
                  child: Text('Email (Z → A)'),
                ),
                DropdownMenuItem(
                  value: 'phone|asc',
                  child: Text('Phone (A → Z)'),
                ),
                DropdownMenuItem(
                  value: 'phone|desc',
                  child: Text('Phone (Z → A)'),
                ),
                DropdownMenuItem(
                  value: 'created_at|desc',
                  child: Text('Ngày tạo (mới nhất)'),
                ),
                DropdownMenuItem(
                  value: 'created_at|asc',
                  child: Text('Ngày tạo (cũ nhất)'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

                final parts = value.split('|');
                setState(() {
                  _sortBy = parts[0];
                  _sort = parts[1];
                });
              },
            ),
            SizedBox(height: 50),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: CustomButton(
                    colorBackground: Colors.transparent,
                    colorBorder: Colors.blue.withValues(alpha: .5),
                    textButton: const Text('Đặt lại'),
                    onTap: () {
                      setState(() {
                        _selectedRole = null;
                        _selectedStatus = null;
                        _sortBy = 'full_name';
                        _sort = 'asc';
                      });
                      _bloc.add(
                        UserManagementEvent.getAll(
                          search: _bloc.state.search,
                          sortBy: _sortBy,
                          sort: _sort,
                          filter: {},
                        ),
                      );
                    },
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 100,
                  child: CustomButton(
                    colorBackground: Colors.blue,
                    textButton: const Text(
                      'Xác nhận',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      widget.onClose();
                      _bloc.add(
                        UserManagementEvent.getAll(
                          search: _bloc.state.search,
                          sortBy: _sortBy,
                          sort: _sort,
                          filter: {
                            'role_code': _selectedRole,
                            'status': _selectedStatus,
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
