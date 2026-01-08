import 'package:flutter/material.dart';

class NoteWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String note;
  const NoteWidget({
    super.key,
    required this.icon,
    required this.note,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        spacing: 5,
        children: [
          Icon(icon, color: color),
          Expanded(
            child: Text(
              note,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
