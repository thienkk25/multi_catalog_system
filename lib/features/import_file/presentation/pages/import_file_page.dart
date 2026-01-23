import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';
import 'package:multi_catalog_system/core/notifications/notification_cubit.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/custom_dropdown_button.dart';
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

class _ImportFilePageState extends State<ImportFilePage> {
  Map<String, dynamic>? fileInfo;
  dynamic file;

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
      fileInfo = {'name': picked.name, 'file_size': picked.size};

      if (kIsWeb) {
        file = picked.bytes;
      } else {
        file = File(picked.path!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nhập Dữ liệu từ Tệp',
          style: TextStyle(fontWeight: FontWeight(600), fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: BlocListener<ImportFileBloc, ImportFileState>(
        listener: (context, state) {
          if (state.error != null) {
            context.read<NotificationCubit>().error(state.error!);
          }

          if (state.success != null) {
            context.read<NotificationCubit>().success(state.success!);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chọn tệp để tải lên',
                    style: TextStyle(fontWeight: FontWeight(600), fontSize: 24),
                  ),
                  Text(
                    'Định dạng hỗ trợ: .CSV, .XLSX',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  SizedBox(height: 20),
                  ImportFileDashedBoderWidget(
                    color: Colors.grey,
                    strokeWidth: 2,
                    child: Container(
                      height: 220,
                      width: double.infinity,
                      padding: EdgeInsets.all(40),
                      child: Column(
                        spacing: 20,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
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
                              colorBackground: Colors.grey.withValues(
                                alpha: .2,
                              ),
                              textButton: Text(
                                'Chọn Tệp',
                                style: TextStyle(fontWeight: FontWeight(600)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
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
                  SizedBox(height: 20),
                  CustomDropdownButton(
                    lable: Text(
                      'Loại dữ liệu',
                      style: TextStyle(fontWeight: FontWeight(600)),
                    ),
                    value: widget.typeImport,
                    items: [
                      DropdownMenuItem(value: 0, child: Text('Tất cả')),
                      DropdownMenuItem(value: 1, child: Text('Lĩnh vực')),
                      DropdownMenuItem(value: 2, child: Text('Nhóm danh mục')),
                      DropdownMenuItem(value: 3, child: Text('Mục danh mục')),
                    ],
                    onChanged: widget.typeImport != 0 ? null : (value) {},
                  ),
                  SizedBox(height: 40),
                  BlocSelector<ImportFileBloc, ImportFileState, bool>(
                    selector: (state) => state.isLoading,
                    builder: (context, isLoading) => CustomButton(
                      onTap: isLoading ? null : () => _onImportFile(),
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
      ),
    );
  }

  void _onImportFile() {
    if (fileInfo == null || file == null) return;
    if (widget.typeImport == 0) {
      context.read<ImportFileBloc>().add(
        ImportFileEvent.importSingleFile(
          file: PickedDocumentFile(
            file: kIsWeb ? null : file!,
            bytes: kIsWeb ? file! : null,
            name: fileInfo!['name'],
            size: fileInfo!['file_size'],
          ),
          type: widget.typeImport,
        ),
      );
    } else {
      context.read<ImportFileBloc>().add(
        ImportFileEvent.importSingleFile(
          file: PickedDocumentFile(
            file: kIsWeb ? null : file!,
            bytes: kIsWeb ? file! : null,
            name: fileInfo!['name'],
            size: fileInfo!['file_size'],
          ),
          type: widget.typeImport,
        ),
      );
    }
  }
}
