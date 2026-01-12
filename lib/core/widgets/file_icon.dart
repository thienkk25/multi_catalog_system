import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FileIcon extends StatelessWidget {
  final String fileName;
  final double size;
  final Widget? iconCustom;

  const FileIcon({
    super.key,
    required this.fileName,
    this.size = 24,
    this.iconCustom,
  });

  @override
  Widget build(BuildContext context) {
    final ext = fileName.split('.').last.toLowerCase();
    Widget? iconCus = iconCustom;
    late IconData icon;
    late Color color;

    switch (ext) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;

      case 'doc':
      case 'docx':
        icon = Icons.description;
        color = Colors.blue;
        break;

      case 'xls':
      case 'xlsx':
      case 'csv':
        color = Colors.green;
        iconCus = SvgPicture.asset(
          'assets/icons/excel-file-type-svgrepo-com.svg',
          height: 30,
          width: 30,
          colorFilter: ColorFilter.mode(Colors.green, BlendMode.srcIn),
        );
        break;

      default:
        icon = Icons.insert_drive_file;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color.withValues(alpha: .15),
      ),
      child: iconCus ?? Icon(icon, color: color, size: size),
    );
  }
}
