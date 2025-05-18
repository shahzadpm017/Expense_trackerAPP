import '../widgets/avatar_picker.dart';

class Profile {
  String name;
  String email;
  String? avatarUrl; // URL or file path for custom image
  AvatarOption? avatarOption; // For predefined avatars
  double monthlyBudget;
  bool enableNotifications;
  String defaultCurrency;

  Profile({
    required this.name,
    required this.email,
    this.avatarUrl,
    this.avatarOption,
    required this.monthlyBudget,
    this.enableNotifications = true,
    this.defaultCurrency = '₹',
  });

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

  factory Profile.fromJson(Map<String, dynamic> json) {
    final avatarOptionName = json['avatarOption'] as String?;
    final avatarOption = avatarOptionName != null
        ? AvatarPicker.avatarOptions.firstWhere(
            (option) => option.name == avatarOptionName,
            orElse: () => AvatarPicker.avatarOptions.first,
          )
        : null;

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
