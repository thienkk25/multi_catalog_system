import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';
import 'package:multi_catalog_system/core/utils/extensions/auth_permission_extension.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/custom_dropdown_button.dart';
import 'package:multi_catalog_system/core/widgets/note_widget.dart';
import 'package:multi_catalog_system/features/import_file/presentation/bloc/import_file_bloc.dart';
import 'package:multi_catalog_system/features/import_file/presentation/bloc/import_file_event.dart';
import 'package:multi_catalog_system/features/import_file/presentation/bloc/import_file_state.dart';
import 'package:multi_catalog_system/features/import_file/presentation/widgets/import_file_dashed_boder_widget.dart';
import 'package:multi_catalog_system/features/import_file/presentation/widgets/import_file_file_card.dart';

class ImportFilePage extends StatefulWidget {
  final int? typeImport;
  const ImportFilePage({super.key, this.typeImport});

  @override
  State<ImportFilePage> createState() => _ImportFilePageState();
}

class _ImportFilePageState extends State<ImportFilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final verticalController = ScrollController();
  final horizontalController = ScrollController();
  Map<String, dynamic>? _fileInfo;
  dynamic _file;

  int? _type;

  bool get _isAdmin => context.hasRole('admin');

  List<DropdownMenuItem<int>> get _items => [
    if (_isAdmin)
      const DropdownMenuItem(value: 0, child: Text('Lĩnh vực + Nhóm + Mục')),
    if (_isAdmin) const DropdownMenuItem(value: 1, child: Text('Lĩnh vực')),
    const DropdownMenuItem(value: 2, child: Text('Nhóm danh mục')),
    const DropdownMenuItem(value: 3, child: Text('Mục danh mục')),
    if (_isAdmin) const DropdownMenuItem(value: 4, child: Text('API Key')),
    if (_isAdmin)
      const DropdownMenuItem(value: 5, child: Text('Quản lý Người dùng')),
  ];

  Future<void> _importFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: kIsWeb,
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv'],
    );

    if (result == null) return;

    final picked = result.files.first;

    setState(() {
      _fileInfo = {
        'name': picked.name,
        'path': picked.path,
        'file_size': picked.size,
      };

      if (kIsWeb) {
        _file = picked.bytes;
      } else {
        _file = File(picked.path!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.typeImport != null) {
      _type = widget.typeImport;
    }
    return BlocListener<ImportFileBloc, ImportFileState>(
      listener: (context, state) {
        if (state.error != null) {
          context.notificationCubit.error(state.error!);
        }

        if (state.success != null) {
          context.notificationCubit.success(state.success!);
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chọn tệp để tải lên',
                  style: TextStyle(fontWeight: FontWeight(600), fontSize: 24),
                ),
                Text(
                  'Định dạng hỗ trợ: .CSV, .XLSX',
                  style: TextStyle(color: Colors.grey[500]),
                ),
                const SizedBox(height: 20),
                ImportFileDashedBoderWidget(
                  color: Colors.grey,
                  strokeWidth: 2,
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      spacing: 20,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue.withValues(alpha: .2),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/upload-file-2-svgrepo-com.svg',
                            height: 40,
                            width: 40,
                            colorFilter: ColorFilter.mode(
                              Colors.blue,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: CustomButton(
                            onTap: () async {
                              await _importFile();
                            },
                            colorBackground: Colors.grey.withValues(alpha: .2),
                            textButton: const Text(
                              'Chọn Tệp',
                              style: TextStyle(fontWeight: FontWeight(600)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_fileInfo != null && _file != null)
                  ImportFileFileCard(
                    fileInfo: _fileInfo!,
                    onRemove: () {
                      setState(() {
                        _fileInfo = null;
                        _file = null;
                      });
                    },
                  ),
                const SizedBox(height: 20),
                CustomDropdownButton<int>(
                  lable: const Text(
                    'Loại dữ liệu',
                    style: TextStyle(fontWeight: FontWeight(600)),
                  ),
                  hint: '--- Chọn loại dữ liệu ---',
                  value: _type,
                  items: _items,
                  onChanged: (value) {
                    setState(() {
                      _type = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                if (_type != null)
                  NoteWidget(
                    icon: Icons.info,
                    color: Colors.blue,
                    note: _noteInforByType(_type),
                  ),
                const SizedBox(height: 10),
                const NoteWidget(
                  icon: Icons.warning,
                  color: Colors.red,
                  note:
                      'Chú ý: Khi import bản ghi trùng mã có thể bị ghi đè dữ liệu.',
                ),
                const SizedBox(height: 20),
                BlocSelector<ImportFileBloc, ImportFileState, bool>(
                  selector: (state) => state.isLoading,
                  builder: (context, isLoading) => CustomButton(
                    onTap: isLoading ? null : () => _onImportFile(context),
                    colorBackground: isLoading ? Colors.grey : Colors.blue,
                    textButton: isLoading
                        ? const CustomCircularProgressButton()
                        : const Text(
                            'Nhập dữ liệu',
                            style: TextStyle(
                              fontWeight: FontWeight(600),
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Kết quả: '),
                BlocSelector<
                  ImportFileBloc,
                  ImportFileState,
                  Map<String, dynamic>?
                >(
                  selector: (state) => state.result,
                  builder: (context, result) {
                    if (result == null) {
                      return Container(
                        height: 40,
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade300),
                        ),
                      );
                    }
                    final prettyJson = const JsonEncoder.withIndent(
                      '  ',
                    ).convert(result);

                    return Container(
                      height: 300,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade300),
                      ),
                      child: Scrollbar(
                        controller: verticalController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: verticalController,
                          child: Scrollbar(
                            controller: horizontalController,
                            thumbVisibility: true,
                            notificationPredicate: (notif) => notif.depth == 1,
                            child: SingleChildScrollView(
                              controller: horizontalController,
                              scrollDirection: Axis.horizontal,
                              child: SelectableText(
                                prettyJson,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _noteInforByType(int? type) {
    switch (type) {
      case 0:
        return 'Tệp dũ liệu phải chứa đầy đủ 3 cấp: Lĩnh vực → Nhóm danh mục → Mục danh mục. Dữ liệu sẽ được nhập theo thứ tự và tự động liên kết.';

      case 1:
        return 'Chỉ nhập dữ liệu tệp danh sách Lĩnh vực.';

      case 2:
        return 'Nhập dữ liệu tệp Nhóm danh mục. Mỗi nhóm phải tham chiếu tới Lĩnh vực đã tồn tại trong hệ thống.';

      case 3:
        return 'Nhập dữ liệu tệp Mục danh mục. Mỗi mục phải liên kết với Nhóm danh mục tương ứng.';

      case 4:
        return 'Quản lý API Key. Dùng để tạo khóa nhanh bằng tệp. Cho phép Import danh sách khóa nhanh và phân quyền truy cập cho hệ thống bên ngoài.';

      case 5:
        return 'Quản lý Người dùng. Cho phép nhập dữ liệu tệp danh sách người dùng và phân quyền truy cập.';

      default:
        return '';
    }
  }

  void _onImportFile(BuildContext context) {
    if (_fileInfo == null || _file == null || _type == null) {
      context.notificationCubit.warning(
        'Vui lòng chọn file cần nhập hoặc loại dữ liệu',
      );
      return;
    }
    if (_type == 0) {
      context.importFileBloc.add(
        ImportFileEvent.importCatalogFile(
          file: PickedDocumentFile(
            file: kIsWeb ? null : _file!,
            bytes: kIsWeb ? _file! : null,
            name: _fileInfo!['name'],
            path: _fileInfo!['path'],
            size: _fileInfo!['file_size'],
          ),
        ),
      );
    } else {
      context.importFileBloc.add(
        ImportFileEvent.importSingleFile(
          file: PickedDocumentFile(
            file: kIsWeb ? null : _file!,
            bytes: kIsWeb ? _file! : null,
            name: _fileInfo!['name'],
            path: _fileInfo!['path'],
            size: _fileInfo!['file_size'],
          ),
          type: _type!,
        ),
      );
    }
  }
}
