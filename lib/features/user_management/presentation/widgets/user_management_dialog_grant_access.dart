import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/role/role_entry.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_dropdown_button.dart';
import 'package:multi_catalog_system/features/user_management/domain/entities/user_management_entry.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_bloc.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_event.dart';

class UserManagementDialogGrantAccess extends StatefulWidget {
  final UserManagementBloc bloc;
  final UserManagementEntry entry;
  const UserManagementDialogGrantAccess({
    super.key,
    required this.entry,
    required this.bloc,
  });

  @override
  State<UserManagementDialogGrantAccess> createState() =>
      _UserManagementDialogGrantAccessState();
}

class _UserManagementDialogGrantAccessState
    extends State<UserManagementDialogGrantAccess> {
  int? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.entry.role?.id;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      elevation: 0,
      alignment: Alignment.center,
      insetPadding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                widget.entry.fullName ?? 'Chưa cập nhật',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                widget.entry.email ?? '-',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 12),
            CustomDropdownButton(
              lable: Text(
                'Quyền',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              hint: '---',
              value: _selectedRole,
              items: const [
                DropdownMenuItem(
                  value: 1,
                  child: Text('Quản trị hệ thống cấp cao'),
                ),
                DropdownMenuItem(value: 2, child: Text('Chuyên viên duyệt')),
                DropdownMenuItem(value: 3, child: Text('Cán bộ chuyên môn')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
            ),
            const SizedBox(height: 12),
            if (_selectedRole == 3) _permissionDomains(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    colorBackground: Colors.transparent,
                    colorBorder: Colors.blue,
                    textButton: Text(
                      'Hủy',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () => context.pop(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    colorBackground: Colors.blue,
                    textButton: Text(
                      'Xác nhận',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      final domains = widget.entry.domains;
                      widget.bloc.add(
                        UserManagementEvent.grantAccess(
                          entry: UserManagementEntry(
                            id: widget.entry.id,
                            role: RoleEntry(id: _selectedRole),
                            domains: domains,
                          ),
                        ),
                      );
                      context.pop();
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

  Widget _permissionDomains() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lĩnh vực được phân quyền',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...(widget.entry.domains ?? []).map(
                (field) => Chip(
                  label: Text(
                    field.name,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() => (widget.entry.domains ?? []).remove(field));
                  },
                  backgroundColor: Colors.blue.shade50,
                  side: BorderSide(color: Colors.blue.shade200),
                ),
              ),
              Row(
                spacing: 8,
                children: [
                  ActionChip(
                    label: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Chọn thêm lĩnh vực',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.add, size: 18, color: Colors.blue),
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                    side: BorderSide(color: Colors.blue.shade300),
                    onPressed: () async {
                      final result =
                          await context.pushNamed(
                                RouterNames.userManagementAddDomains,
                                extra: (widget.entry.domains ?? []),
                              )
                              as List<DomainRefEntry>?;

                      if (result == null) return;

                      setState(
                        () => (widget.entry.domains ?? [])
                          ..clear()
                          ..addAll(result),
                      );
                    },
                  ),
                  if ((widget.entry.domains ?? []).isNotEmpty)
                    ActionChip(
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Xóa tất cả',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.remove, size: 18, color: Colors.blue),
                        ],
                      ),
                      backgroundColor: Colors.transparent,
                      side: BorderSide(color: Colors.blue.shade300),
                      onPressed: () {
                        setState(() {
                          (widget.entry.domains ?? []).clear();
                        });
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
