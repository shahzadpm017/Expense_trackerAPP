// Main entry point of the Flutter application
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

// The main function that starts the app
void main() {
  runApp(const ExpenseTrackerApp());
}

// Root widget of the application
class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  // Custom color constants for the app theme
  static const _primaryColor = Color(0xFF6366F1); // Main brand color (Indigo)
  static const _secondaryColor = Color(0xFFA5B4FC); // Secondary accent color
  static const _tertiaryColor = Color(0xFFE0E7FF); // Light accent color
  static const _errorColor = Color(0xFFEF4444); // Error/warning color (Red)
  static const _backgroundColor = Color(0xFFF8FAFC); // Light mode background
  static const _surfaceColor = Colors.white; // Light mode surface color
  static const _darkBackgroundColor = Color(0xFF1A1A1A); // Dark mode background
  static const _darkSurfaceColor = Color(0xFF2D2D2D); // Dark mode surface color

  // Configure the light theme for the app
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true, // Enable Material Design 3
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor, // Generate color scheme from primary color
        secondary: _secondaryColor,
        tertiary: _tertiaryColor,
        error: _errorColor,
        background: _backgroundColor,
        surface: _surfaceColor,
        brightness: Brightness.light,
      ),
      // Configure AppBar appearance for light theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _primaryColor),
        titleTextStyle: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Configure Card appearance for light theme
      cardTheme: CardTheme(
        color: _surfaceColor,
        elevation: 2,
        shadowColor: _primaryColor.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      // Configure FloatingActionButton appearance for light theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Color(0xFF1E293B),
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: Color(0xFF334155),
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: Color(0xFF475569),
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF64748B),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: _primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF1E293B),
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Configure the dark theme for the app
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _tertiaryColor,
        error: _errorColor,
        background: _darkBackgroundColor,
        surface: _darkSurfaceColor,
        brightness: Brightness.dark,
      ),
      // Dark theme specific configurations
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _secondaryColor),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        color: _darkSurfaceColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      // Text styles for dark theme
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: Color(0xFFE2E8F0),
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: Color(0xFFCBD5E1),
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF94A3B8),
        ),
      ),
      // Input field styling for dark theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: _secondaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      // Snackbar styling for dark theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _darkSurfaceColor,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Build the MaterialApp widget with configured themes
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner
      title: 'Expense Tracker',
      theme: _buildLightTheme(), // Set light theme
      darkTheme: _buildDarkTheme(), // Set dark theme
      themeMode: ThemeMode.system, // Use system theme preference
      home: const HomeScreen(), // Set initial screen
    );
  }
}
