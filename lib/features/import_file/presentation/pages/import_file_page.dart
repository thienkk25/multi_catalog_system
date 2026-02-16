import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';
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
  const ImportFilePage({super.key, required this.typeImport});
  final int typeImport;

  @override
  State<ImportFilePage> createState() => _ImportFilePageState();
}

class _ImportFilePageState extends State<ImportFilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Map<String, dynamic>? fileInfo;
  dynamic file;

  int type = 1;

  @override
  void initState() {
    super.initState();
    if (widget.typeImport != 0) {
      type = widget.typeImport;
    }
  }

  Future<void> importFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: kIsWeb,
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv'],
    );

    if (result == null) return;

    final picked = result.files.first;

    setState(() {
      fileInfo = {
        'name': picked.name,
        'path': picked.path,
        'file_size': picked.size,
      };

      if (kIsWeb) {
        file = picked.bytes;
      } else {
        file = File(picked.path!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                              await importFile();
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
                if (fileInfo != null && file != null)
                  ImportFileFileCard(
                    fileInfo: fileInfo!,
                    onRemove: () {
                      setState(() {
                        fileInfo = null;
                        file = null;
                      });
                    },
                  ),
                const SizedBox(height: 20),
                CustomDropdownButton<int>(
                  lable: const Text(
                    'Loại dữ liệu',
                    style: TextStyle(fontWeight: FontWeight(600)),
                  ),
                  value: type,
                  items: [
                    const DropdownMenuItem(
                      value: 0,
                      child: Text('Lĩnh vực + Nhóm danh mục + Mục danh mục'),
                    ),
                    const DropdownMenuItem(value: 1, child: Text('Lĩnh vực')),
                    const DropdownMenuItem(
                      value: 2,
                      child: Text('Nhóm danh mục'),
                    ),
                    const DropdownMenuItem(
                      value: 3,
                      child: Text('Mục danh mục'),
                    ),
                    const DropdownMenuItem(
                      value: 4,
                      child: Text('Văn bản pháp lý'),
                    ),
                    const DropdownMenuItem(value: 5, child: Text('API Key')),
                    const DropdownMenuItem(
                      value: 6,
                      child: Text('Quản lý Người dùng'),
                    ),
                  ],
                  onChanged: widget.typeImport != 0
                      ? null
                      : (value) {
                          setState(() {
                            type = value!;
                          });
                        },
                ),
                const SizedBox(height: 20),
                NoteWidget(
                  icon: Icons.info,
                  color: Colors.blue,
                  note: _noteInforByType(type),
                ),
                const SizedBox(height: 10),
                const NoteWidget(
                  icon: Icons.warning,
                  color: Colors.red,
                  note:
                      'Chú ý: Khi import bản ghi trùng mã có thể bị ghi đè dữ liệu.',
                ),
                const SizedBox(height: 40),
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
        return 'File CSV phải chứa đầy đủ 3 cấp: Lĩnh vực → Nhóm danh mục → Mục danh mục. Dữ liệu sẽ được import theo thứ tự và tự động liên kết.';

      case 1:
        return 'Chỉ import danh sách Lĩnh vực.';

      case 2:
        return 'Import Nhóm danh mục. Mỗi nhóm phải tham chiếu tới Lĩnh vực đã tồn tại trong hệ thống.';

      case 3:
        return 'Import Mục danh mục. Mỗi mục phải liên kết với Nhóm danh mục tương ứng.';

      case 4:
        return 'Import Văn bản pháp lý. Có thể bao gồm số hiệu, ngày ban hành và file đính kèm.';

      case 5:
        return 'Quản lý API Key. Dùng để tạo, cập nhật hoặc thu hồi khóa truy cập cho hệ thống bên ngoài.';

      case 6:
        return 'Quản lý Người dùng. Cho phép import danh sách người dùng và phân quyền truy cập.';

      default:
        return '';
    }
  }

  void _onImportFile(BuildContext context) {
    if (fileInfo == null || file == null) return;
    if (type == 0) {
      context.importFileBloc.add(
        ImportFileEvent.importSingleFile(
          file: PickedDocumentFile(
            file: kIsWeb ? null : file!,
            bytes: kIsWeb ? file! : null,
            name: fileInfo!['name'],
            path: fileInfo!['path'],
            size: fileInfo!['file_size'],
          ),
          type: type,
        ),
      );
    } else {
      context.importFileBloc.add(
        ImportFileEvent.importSingleFile(
          file: PickedDocumentFile(
            file: kIsWeb ? null : file!,
            bytes: kIsWeb ? file! : null,
            name: fileInfo!['name'],
            path: fileInfo!['path'],
            size: fileInfo!['file_size'],
          ),
          type: type,
        ),
      );
    }
  }
}
