// Import avatar picker widget for handling profile pictures
import '../widgets/avatar_picker.dart';

// Represents user profile information and preferences
class Profile {
  String name; // User's display name
  String email; // User's email address
  String? avatarUrl; // Custom profile picture URL/path
  AvatarOption? avatarOption; // Selected predefined avatar option
  double monthlyBudget; // User's monthly spending limit
  bool enableNotifications; // Notification preferences
  String defaultCurrency; // Preferred currency symbol

  // Constructor with required and optional fields
  Profile({
    required this.name,
    required this.email,
    this.avatarUrl,
    this.avatarOption,
    required this.monthlyBudget,
    this.enableNotifications = true, // Notifications enabled by default
    this.defaultCurrency = '₹', // Default to Indian Rupee
  });

  // Convert profile data to JSON format for storage/transmission
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'avatarOption': avatarOption?.name,
      'monthlyBudget': monthlyBudget,
      'enableNotifications': enableNotifications,
      'defaultCurrency': defaultCurrency,
    };
  }

  // Create a Profile instance from JSON data
  factory Profile.fromJson(Map<String, dynamic> json) {
    // Find matching avatar option from predefined list
    final avatarOptionName = json['avatarOption'] as String?;
    final avatarOption = avatarOptionName != null
        ? AvatarPicker.avatarOptions.firstWhere(
            (option) => option.name == avatarOptionName,
            orElse: () => AvatarPicker.avatarOptions.first,
          )
        : null;

    // Construct and return new Profile instance
    return Profile(
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      avatarOption: avatarOption,
      monthlyBudget: json['monthlyBudget'] as double,
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      defaultCurrency: json['defaultCurrency'] as String? ?? '₹',
    );
  }

  // Create a copy of Profile with optional field updates
  Profile copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    AvatarOption? avatarOption,
    double? monthlyBudget,
    bool? enableNotifications,
    String? defaultCurrency,
  }) {
    return Profile(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarOption: avatarOption ?? this.avatarOption,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
    );
  }
}
