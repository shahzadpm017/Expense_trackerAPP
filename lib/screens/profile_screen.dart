import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/avatar_picker.dart';

class ProfileScreen extends StatefulWidget {
  final Profile profile;
  final Function(Profile) onProfileUpdate;

  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onProfileUpdate,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _budgetController;
  late Profile _profile;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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

  bool get _isInitialSetup =>
      widget.profile.name == 'User' &&
      widget.profile.email == 'user@example.com' &&
      widget.profile.monthlyBudget == 0;

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedProfile = _profile.copyWith(
      name: _nameController.text,
      email: _emailController.text,
      monthlyBudget:
          double.tryParse(_budgetController.text) ?? _profile.monthlyBudget,
    );
    widget.onProfileUpdate(updatedProfile);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isInitialSetup
            ? 'Profile setup completed! You can now start tracking expenses.'
            : 'Profile updated successfully'),
      ),
    );
  }

  void _handleAvatarTap() {
    showDialog(
      context: context,
      builder: (context) => AvatarPicker(
        selectedAvatar: _profile.avatarOption,
        currentImagePath: _profile.avatarUrl,
        onSelect: (selectedAvatar) {
          setState(() {
            _profile = _profile.copyWith(
              avatarOption: selectedAvatar,
              avatarUrl: null, // Clear custom avatar when using predefined one
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
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isInitialSetup ? 'Setup Profile' : 'Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_isInitialSetup)
                Card(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 48,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Welcome to Expense Tracker!',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Let\'s set up your profile to get started with expense tracking.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ProfileAvatar(
                avatarUrl: _profile.avatarUrl,
                avatarOption: _profile.avatarOption,
                onTap: _handleAvatarTap,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _budgetController,
                decoration: InputDecoration(
                  labelText: 'Monthly Budget',
                  prefixIcon: const Icon(Icons.account_balance_wallet),
                  prefixText: _profile.defaultCurrency + ' ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your monthly budget';
                  }
                  final budget = double.tryParse(value);
                  if (budget == null || budget <= 0) {
                    return 'Please enter a valid budget amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle:
                    const Text('Get alerts for budget limits and reminders'),
                value: _profile.enableNotifications,
                onChanged: (value) {
                  setState(() {
                    _profile = _profile.copyWith(enableNotifications: value);
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    Text(_isInitialSetup ? 'Complete Setup' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
