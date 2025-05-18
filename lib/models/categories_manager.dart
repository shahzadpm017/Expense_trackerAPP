import 'package:uuid/uuid.dart';
import 'expense.dart';

class CategoriesManager {
  final List<ExpenseCategory> _categories = [];
  final _uuid = const Uuid();

  List<ExpenseCategory> get categories => List.unmodifiable(_categories);

  void addCategory(String name, String icon) {
    final category = ExpenseCategory(
      id: _uuid.v4(),
      name: name,
      icon: icon,
    );
    _categories.add(category);
  }

  void removeCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
  }

  ExpenseCategory? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}
