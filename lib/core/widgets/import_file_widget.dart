import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';

class ImportFileWidget extends StatelessWidget {
  const ImportFileWidget({super.key});

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
                DashedBorder(
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
                            onTap: () {},
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
                CustomCard(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.green.withValues(alpha: .2),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/document-svgrepo-com.svg',
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                            Colors.green,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Danh-muc-abc.xlsx',
                            style: TextStyle(
                              fontWeight: FontWeight(600),
                              fontSize: 16,
                            ),
                          ),
                          Text('1.2 MB', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
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

class DashedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  const DashedBorder({
    super.key,
    required this.child,
    this.color = Colors.grey,
    this.strokeWidth = 2.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final dashPath = Path();
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = distance + dashWidth;
        final extractPath = metric.extractPath(
          distance,
          nextDistance > metric.length ? metric.length : nextDistance,
        );
        dashPath.addPath(extractPath, Offset.zero);
        distance = nextDistance + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
