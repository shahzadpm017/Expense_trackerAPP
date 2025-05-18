import 'package:uuid/uuid.dart';

const uuid = Uuid();

class ExpenseCategory {
  final String id;
  final String name;
  final String icon;

  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }
}
