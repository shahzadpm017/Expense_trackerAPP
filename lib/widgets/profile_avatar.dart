import 'dart:io';
import 'package:flutter/material.dart';
import 'avatar_picker.dart';

class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final AvatarOption? avatarOption;
  final VoidCallback? onTap;
  final double size;

  const ProfileAvatar({
    super.key,
    this.avatarUrl,
    this.avatarOption,
    this.onTap,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: size / 2,
            backgroundColor: avatarOption?.color.withOpacity(0.2) ??
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
            backgroundImage: avatarUrl != null
                ? (avatarUrl!.startsWith('http')
                    ? NetworkImage(avatarUrl!) as ImageProvider
                    : FileImage(File(avatarUrl!)))
                : null,
            child: avatarUrl == null
                ? Icon(
                    avatarOption?.icon ?? Icons.person,
                    size: size * 0.5,
                    color: avatarOption?.color ??
                        Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
          if (onTap != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  size: size * 0.2,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
