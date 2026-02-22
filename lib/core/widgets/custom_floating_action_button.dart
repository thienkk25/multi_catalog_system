import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_catalog_system/core/widgets/role_based_widget.dart';

class CustomFloatingActionButton extends StatefulWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.onPressedImport,
    required this.onPressedAdd,
    this.permission,
  });

  final List<String>? permission;
  final VoidCallback onPressedImport;
  final VoidCallback onPressedAdd;

  @override
  State<CustomFloatingActionButton> createState() =>
      _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState
    extends State<CustomFloatingActionButton> {
  bool isOpen = false;

  void toggle() {
    setState(() {
      isOpen = !isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      permission: widget.permission ?? ['admin', 'domainOfficer'],
      child: Positioned(
        right: 20,
        bottom: 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IgnorePointer(
              ignoring: !isOpen,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: isOpen ? 1 : 0,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 250),
                      scale: isOpen ? 1 : .8,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _actionButton(
                          label: 'Import bằng file',
                          icon: SvgPicture.asset(
                            'assets/icons/import-svgrepo-com.svg',
                            height: 20,
                            width: 20,
                          ),
                          onTap: isOpen ? widget.onPressedImport : null,
                        ),
                      ),
                    ),
                  ),

                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isOpen ? 1 : 0,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: isOpen ? 1 : .8,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _actionButton(
                          label: 'Thêm thủ công',
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                          onTap: isOpen ? widget.onPressedAdd : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: toggle,
              child: AnimatedRotation(
                turns: isOpen ? 0.125 : 0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: const [
                      BoxShadow(blurRadius: 8, color: Colors.black26),
                    ],
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/menu-2-svgrepo-com.svg',
                    height: 30,
                    width: 30,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Widget icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap == null
          ? null
          : () {
              toggle();
              onTap();
            },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(label, style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(50),
            ),
            child: icon,
          ),
        ],
      ),
    );
  }
}
