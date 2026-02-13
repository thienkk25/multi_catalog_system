import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/custom_alert_dialog.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/custom_label.dart';
import 'package:multi_catalog_system/core/widgets/role_based_widget.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_event.dart';

class ApproveCard extends StatelessWidget {
  final CategoryItemVersionEntry version;
  const ApproveCard({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    CategoryItemEntry item = CategoryItemEntry(
      id: version.itemId,
      code: version.oldValue?['code'] ?? '',
      name: version.oldValue?['name'] ?? '',
      description: version.oldValue?['description'] ?? '',
    );

    if (version.changeType == 'create') {
      item = CategoryItemEntry(
        id: version.itemId,
        code: version.newValue?['code'] ?? '',
        name: version.newValue?['name'] ?? '',
        description: version.newValue?['description'] ?? '',
      );
    }

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${item.code} - ${item.name}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _statusChip(version.status),
              ],
            ),

            const Divider(),

            const Text(
              "Thông tin danh mục",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _infoRow("Mã", item.code),
            _infoRow("Tên", item.name),
            _infoRow("Mô tả", item.description),
            const SizedBox(height: 10),

            const Text(
              "Thông tin thay đổi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _infoRow("Loại", _statusType(version.changeType)),
            _infoRow("ID Người gửi", version.changeBy),
            _infoRow("Nội dung", version.changeSummary),

            version.status == 'rejected'
                ? Column(
                    children: [
                      const Divider(),
                      _infoRow("Lý do", version.rejectReason),
                    ],
                  )
                : const SizedBox.shrink(),

            const SizedBox(height: 10),

            ExpansionTile(
              title: const Text("So sánh thay đổi"),
              backgroundColor: Colors.transparent,
              collapsedBackgroundColor: Colors.blue.withValues(alpha: .05),
              collapsedTextColor: Colors.blue,
              collapsedIconColor: Colors.blue,
              children: [_diffCompareTable(version.oldValue, version.newValue)],
            ),

            version.status == 'pending'
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      RoleBasedWidget(
                        permission: ['approver'],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 120,
                              child: CustomButton(
                                onTap: () => _confirmReject(
                                  context: context,
                                  id: version.id!,
                                ),
                                colorBackground: Colors.red,
                                textButton: const Text(
                                  "Từ chối",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: CustomButton(
                                onTap: () => _confirmApprove(
                                  context: context,
                                  id: version.id!,
                                ),
                                colorBackground: Colors.green,
                                textButton: const Text(
                                  "Duyệt",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      RoleBasedWidget(
                        permission: ['domainOfficer'],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 120,
                              child: CustomButton(
                                onTap: () => _confirmDelete(
                                  context: context,
                                  id: version.id!,
                                ),
                                colorBackground: Colors.red,
                                textButton: const Text(
                                  "Xóa",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: CustomButton(
                                onTap: () {
                                  context.goNamed(
                                    RouterNames.categoryItemForm,
                                    queryParameters: {
                                      'mode': 'updateVersion',
                                      'versionId': version.id.toString(),
                                    },
                                  );
                                },
                                colorBackground: Colors.green,
                                textButton: const Text(
                                  "Chỉnh sửa",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  String _statusType(String? type) {
    String text;
    switch (type) {
      case "create":
        text = "Tạo mới";
        break;
      case "update":
        text = "Cập nhật";
        break;
      case "delete":
        text = "Xoá";
        break;
      default:
        text = '-';
    }
    return text;
  }

  Widget _statusChip(String? status) {
    Color color;
    String text;
    switch (status) {
      case "pending":
        color = Colors.orange;
        text = "Chờ duyệt";
        break;
      case "approved":
        color = Colors.green;
        text = "Đã duyệt";
        break;
      case "rejected":
        color = Colors.red;
        text = "Đã từ chối";
        break;
      default:
        text = '-';
        color = Colors.grey;
    }
    return CustomLabel(text: text, color: color);
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value ?? "-")),
        ],
      ),
    );
  }

  Widget _diffCompareTable(
    Map<String, dynamic>? oldValue,
    Map<String, dynamic>? newValue,
  ) {
    final Set<String> keys = {...?oldValue?.keys, ...?newValue?.keys};

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (keys.isEmpty)
            const Text("-")
          else
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FixedColumnWidth(140),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: Colors.blue),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        "Trường",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        "Giá trị cũ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        "Giá trị mới",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                ...keys.map((key) {
                  final oldVal = oldValue?[key];
                  final newVal = newValue?[key];

                  final changed = _isDifferent(oldVal, newVal);

                  return TableRow(
                    decoration: changed
                        ? BoxDecoration(
                            color: Colors.blue.withValues(alpha: .15),
                          )
                        : null,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          key,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(oldVal?.toString() ?? ""),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(newVal?.toString() ?? ""),
                      ),
                    ],
                  );
                }),
              ],
            ),
        ],
      ),
    );
  }

  bool _isDifferent(dynamic oldVal, dynamic newVal) {
    if (oldVal == null || newVal == null) return false;

    if (oldVal?.toString().trim() == newVal?.toString().trim()) {
      return false;
    }

    if (oldVal is Map && newVal is Map) {
      return !_mapEquals(oldVal, newVal);
    }
    return oldVal != newVal;
  }

  bool _mapEquals(Map a, Map b) {
    if (a.length != b.length) return false;

    for (final key in a.keys) {
      if (!_isDifferent(a[key], b[key]) == true) continue;
      return false;
    }

    return true;
  }

  void _confirmApprove({required BuildContext context, required String id}) {
    showDialog(
      context: context,
      builder: (_) => CustomAlertDialog(
        title: 'Xác nhận',
        content: 'Bạn có chắc chắn muốn DUYỆT bản ghi?',
        confirmText: 'Duyệt',
        onConfirm: () {
          context.itemVersionBloc.add(
            CategoryItemVersionEvent.approveVersion(id: id),
          );
          context.pop();
        },
      ),
    );
  }

  void _confirmReject({required BuildContext context, required String id}) {
    showDialog(
      context: context,
      builder: (_) {
        final controller = TextEditingController();
        final formKey = GlobalKey<FormState>();
        return Form(
          key: formKey,
          child: AlertDialog(
            title: Text(
              'Từ chối',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: CustomInput(
              controller: controller,
              lable: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Lý do từ chối: ',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              validator: (p0) =>
                  p0 == null || p0.isEmpty ? 'Vui lòng nhập lý do' : null,
              minLines: 5,
              maxLines: 5,
            ),
            actions: [
              OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  context.itemVersionBloc.add(
                    CategoryItemVersionEvent.rejectVersion(
                      id: id,
                      rejectReason: controller.text,
                    ),
                  );
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Từ chối'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete({required BuildContext context, required String id}) {
    showDialog(
      context: context,
      builder: (_) => CustomAlertDialog(
        onConfirm: () {
          context.itemVersionBloc.add(CategoryItemVersionEvent.delete(id: id));
          context.pop();
        },
      ),
    );
  }
}
