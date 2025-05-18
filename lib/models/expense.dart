// Import UUID package for generating unique identifiers
import 'package:uuid/uuid.dart';

// Create a single instance of Uuid to be used throughout the app
const uuid = Uuid();

// Represents a category for expenses (e.g., Food, Travel, etc.)
class ExpenseCategory {
  final String id; // Unique identifier for the category
  final String name; // Display name of the category
  final String icon; // Icon representation for the category

  // Constructor requiring all fields
  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}

// Represents a single expense entry in the application
class Expense {
  final String id; // Unique identifier for the expense
  final String title; // Description of the expense
  final double amount; // Monetary value of the expense
  final DateTime date; // When the expense occurred
  final ExpenseCategory category; // Category the expense belongs to

  // Constructor that generates a unique ID for each new expense
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4(); // Automatically generate UUID for new expenses

  // Getter to format the date in a readable format (DD/MM/YYYY)
  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }
}
