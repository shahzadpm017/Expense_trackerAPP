import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarOption {
  final String name;
  final IconData icon;
  final Color color;

  const AvatarOption({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class AvatarPicker extends StatelessWidget {
  static const avatarOptions = [
    AvatarOption(
      name: 'person',
      icon: Icons.person,
      color: Colors.blue,
    ),
    AvatarOption(
      name: 'work',
      icon: Icons.work,
      color: Colors.orange,
    ),
    AvatarOption(
      name: 'favorite',
      icon: Icons.favorite,
      color: Colors.red,
    ),
    AvatarOption(
      name: 'star',
      icon: Icons.star,
      color: Colors.purple,
    ),
  ];

  final AvatarOption? selectedAvatar;
  final Function(AvatarOption?) onSelect;
  final Function(String)? onImageSelected;
  final String? currentImagePath;

  const AvatarPicker({
    super.key,
    this.selectedAvatar,
    required this.onSelect,
    this.onImageSelected,
    this.currentImagePath,
  });

  Future<void> _pickImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null && onImageSelected != null) {
        onSelect(null); // Clear predefined avatar when using custom image
        onImageSelected!(image.path);
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Avatar',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                // Gallery option
                InkWell(
                  onTap: () => _pickImage(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: currentImagePath != null
                            ? colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: currentImagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(currentImagePath!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 32,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Gallery',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                  ),
                ),
                // Predefined avatars
                ...avatarOptions.map((option) => InkWell(
                      onTap: () {
                        onSelect(option);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: option.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedAvatar?.name == option.name
                                ? option.color
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              option.icon,
                              size: 32,
                              color: option.color,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              option.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: option.color,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
