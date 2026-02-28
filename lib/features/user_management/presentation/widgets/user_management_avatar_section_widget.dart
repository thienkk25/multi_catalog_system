import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';

class UserManagementAvatarSectionWidget extends StatelessWidget {
  final UserEntry? entry;
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

    return Container(
      width: sizeAvatar ?? 60,
      height: sizeAvatar ?? 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.withValues(alpha: .3),
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
