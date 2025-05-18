import 'package:flutter/material.dart';

// Dialog widget for adding new expense categories
class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  // Controller for category name input
  final _nameController = TextEditingController();

  // Currently selected emoji icon
  String _selectedIcon = '🏷️';

  // List of available emoji icons for categories
  final List<String> _availableIcons = [
    '🏷️', // Label (default)
    '🛒', // Shopping
    '🍔', // Food
    '✈️', // Travel
    '🎮', // Gaming
    '📚', // Education
    '🏠', // Home
    '🚗', // Transport
    '💊', // Health
    '👕', // Clothing
    '🎵', // Entertainment
    '🎁', // Gifts
    '💡', // Utilities
    '📱', // Technology
    '⚡', // Energy
    '🎨', // Art
    '🏃', // Sports
    '🍿', // Movies
    '🎭', // Events
    '💼', // Business
  ];

  @override
  void dispose() {
    // Clean up controller
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Category name input field
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Category Name',
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          const Text('Select Icon'),
          const SizedBox(height: 8),
          // Grid of emoji icons
          Container(
            height: 150,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: _availableIcons.length,
              itemBuilder: (context, index) {
                final icon = _availableIcons[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: icon == _selectedIcon
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        // Add button (enabled only if name is not empty)
        FilledButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isNotEmpty) {
              Navigator.of(context).pop({
                'name': name,
                'icon': _selectedIcon,
              });
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
