import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/avatar_picker.dart';

// Screen for managing user profile information
class ProfileScreen extends StatefulWidget {
  final Profile profile; // Current profile data
  final Function(Profile) onProfileUpdate; // Callback when profile is updated

  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onProfileUpdate,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers for form fields
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _budgetController;

  // Local copy of profile for editing
  late Profile _profile;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize profile and text controllers
    _profile = widget.profile;
    _nameController = TextEditingController(
        text: _profile.name == 'User' ? '' : _profile.name);
    _emailController = TextEditingController(
        text: _profile.email == 'user@example.com' ? '' : _profile.email);
    _budgetController = TextEditingController(
      text:
          _profile.monthlyBudget == 0 ? '' : _profile.monthlyBudget.toString(),
    );
  }

  // Check if this is the initial profile setup
  bool get _isInitialSetup =>
      widget.profile.name == 'User' &&
      widget.profile.email == 'user@example.com' &&
      widget.profile.monthlyBudget == 0;

  // Save profile changes
  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Create updated profile with new values
    final updatedProfile = _profile.copyWith(
      name: _nameController.text,
      email: _emailController.text,
      monthlyBudget:
          double.tryParse(_budgetController.text) ?? _profile.monthlyBudget,
    );

    // Notify parent about profile update
    widget.onProfileUpdate(updatedProfile);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isInitialSetup
            ? 'Profile setup completed! You can now start tracking expenses.'
            : 'Profile updated successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isInitialSetup ? 'Set Up Profile' : 'Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile picture section
                Center(
                  child: Column(
                    children: [
                      ProfileAvatar(
                        size: 120,
                        avatarUrl: _profile.avatarUrl,
                        avatarOption: _profile.avatarOption,
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          // Show avatar picker dialog
                          await showDialog<Map<String, dynamic>>(
                            context: context,
                            builder: (ctx) => AvatarPicker(
                              selectedAvatar: _profile.avatarOption,
                              currentImagePath: _profile.avatarUrl,
                              onSelect: (selectedAvatar) {
                                setState(() {
                                  _profile = _profile.copyWith(
                                    avatarOption: selectedAvatar,
                                    avatarUrl:
                                        null, // Clear custom image when using predefined avatar
                                  );
                                });
                              },
                              onImageSelected: (imagePath) {
                                setState(() {
                                  _profile = _profile.copyWith(
                                    avatarUrl: imagePath,
                                    avatarOption:
                                        null, // Clear predefined avatar when using custom image
                                  );
                                });
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Change Picture'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Monthly budget field
                TextFormField(
                  controller: _budgetController,
                  decoration: InputDecoration(
                    labelText: 'Monthly Budget',
                    prefixIcon:
                        const Icon(Icons.account_balance_wallet_outlined),
                    prefixText: _profile.defaultCurrency,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your monthly budget';
                    }
                    final budget = double.tryParse(value);
                    if (budget == null || budget <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saveProfile,
                    child:
                        Text(_isInitialSetup ? 'Get Started' : 'Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _emailController.dispose();
    _budgetController.dispose();
    super.dispose();
  }
}
