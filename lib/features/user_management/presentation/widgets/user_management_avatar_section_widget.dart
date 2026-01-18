import 'dart:math';

import 'package:flutter/material.dart';
import 'package:multi_catalog_system/features/user_management/domain/entities/user_management_entry.dart';

class UserManagementAvatarSectionWidget extends StatelessWidget {
  final UserManagementEntry? entry;

  const UserManagementAvatarSectionWidget({super.key, this.entry});

  @override
  Widget build(BuildContext context) {
    final sizeAvatar = 60.0;
    final initials = entry?.fullName != null && entry!.fullName!.isNotEmpty
        ? entry!.fullName![0].toUpperCase()
        : '?';

    Color radomColor() {
      return Color.fromARGB(
        255,
        Random().nextInt(256),
        Random().nextInt(256),
        Random().nextInt(256),
      );
    }

    return Container(
      width: sizeAvatar,
      height: sizeAvatar,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: radomColor(),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: .3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
