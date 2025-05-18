// Import UUID for generating unique category IDs
import 'package:uuid/uuid.dart';
import 'expense.dart';

// Manages the creation and organization of expense categories
class CategoriesManager {
  // Private list to store all expense categories
  final List<ExpenseCategory> _categories = [];

  // Instance of UUID generator for creating unique category IDs
  final _uuid = const Uuid();

  // Public getter to access categories (returns unmodifiable list for safety)
  List<ExpenseCategory> get categories => List.unmodifiable(_categories);

  // Add a new category with given name and icon
  void addCategory(String name, String icon) {
    final category = ExpenseCategory(
      id: _uuid.v4(), // Generate unique ID for new category
      name: name,
      icon: icon,
    );
    _categories.add(category);
  }

  // Remove a category by its ID
  void removeCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
  }

  // Find and return a category by its ID
  // Returns null if category is not found
  ExpenseCategory? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}
