import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';

class ProfileAvatarSectionWidget extends StatelessWidget {
  final UserEntry? entry;

  const ProfileAvatarSectionWidget({super.key, this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final initials = entry?.fullName != null && entry!.fullName!.isNotEmpty
        ? entry!.fullName![0].toUpperCase()
        : '?';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xff16d9e3), Color(0xff30c7ec), Color(0xff46aef7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 48,
            ),
          ),
        ),

        const SizedBox(height: 16),

        if (entry?.fullName != null)
          Text(
            entry!.fullName!,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            if (entry?.email != null)
              _InfoChip(icon: Icons.email_outlined, label: entry!.email!),
            if (entry?.role?.name != null)
              _InfoChip(
                icon: Icons.verified_user_outlined,
                label: entry!.role!.name!,
              ),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.blue),
      label: Text(label),
      backgroundColor: Color(0xff16d9e3).withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
