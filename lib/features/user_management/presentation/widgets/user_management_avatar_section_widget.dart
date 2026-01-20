import 'dart:math';

import 'package:flutter/material.dart';
import 'package:multi_catalog_system/features/user_management/domain/entities/user_management_entry.dart';

class UserManagementAvatarSectionWidget extends StatelessWidget {
  final UserManagementEntry? entry;
  final double? sizeAvatar;

  const UserManagementAvatarSectionWidget({
    super.key,
    this.entry,
    this.sizeAvatar,
  });

  @override
  Widget build(BuildContext context) {
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
      width: sizeAvatar ?? 60,
      height: sizeAvatar ?? 60,
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
        style: TextStyle(
          fontSize: sizeAvatar != null ? sizeAvatar! / 2 : 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
