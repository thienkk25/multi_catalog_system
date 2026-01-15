import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/import_file/presentation/widgets/import_file_dashed_boder_widget.dart';
import 'package:multi_catalog_system/features/import_file/presentation/widgets/import_file_list_file_card_widget.dart';

class ImportFilePage extends StatefulWidget {
  const ImportFilePage({
    super.key,
    required this.typeImport,
    this.allowedExtensions,
  });
  final int typeImport;
  final List<String>? allowedExtensions;

  @override
  State<ImportFilePage> createState() => _ImportFilePageState();
}

class _ImportFilePageState extends State<ImportFilePage> {
  final List<Map> data = [];
  List fileAll = [];

  Future<void> importFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: kIsWeb,
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions:
          widget.allowedExtensions ??
          ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'csv'],
    );
    if (result == null) return;
    if (kIsWeb) {
      final List<Uint8List> files = result.files
          .where((e) => e.bytes != null)
          .map((e) => e.bytes!)
          .toList();

      setState(() {
        fileAll = files;
        data.addAll(
          result.files.map((e) => {'name': e.name, 'file_size': e.size}),
        );
      });
    } else {
      List<File> files = result.paths.map((path) => File(path!)).toList();

      setState(() {
        fileAll = files;
        data.addAll(
          result.files.map((e) => {'name': e.name, 'file_size': e.size}),
        );
      });
    }
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
      body: SafeArea(
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
                            colorBackground: Colors.grey.withValues(alpha: .2),
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
                ImportFileListFileCardWidget(data: data),
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
                CustomButton(
                  onTap: () {},
                  colorBackground: Colors.blue,
                  textButton: Text(
                    'Nhập dữ liệu',
                    style: TextStyle(
                      fontWeight: FontWeight(600),
                      color: Colors.white,
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
}
