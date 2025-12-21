import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_catalog_system/core/widgets/role_based_widget.dart';

class CustomFloatingActionButton extends StatefulWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.onPressedImport,
    required this.onPressedAdd,
  });
  final VoidCallback onPressedImport;
  final VoidCallback onPressedAdd;

  @override
  State<CustomFloatingActionButton> createState() =>
      _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState
    extends State<CustomFloatingActionButton> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      permission: ['admin', 'domainOfficer'],
      child: Positioned(
        right: 20,
        bottom: 50,
        child: Column(
          children: [
            isOpen
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        isOpen = false;
                      });
                    },
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: widget.onPressedImport,
                          child: Row(
                            spacing: 5,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  'Import bằng file',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/import-svgrepo-com.svg',
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onPressedAdd,
                          child: Row(
                            spacing: 5,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  'Thêm thủ công',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        isOpen = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/menu-2-svgrepo-com.svg',
                        height: 30,
                        width: 30,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
