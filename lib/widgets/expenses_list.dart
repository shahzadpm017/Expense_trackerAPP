import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'expense_item.dart';

// Widget that displays a scrollable list of expenses with swipe-to-delete functionality
class ExpensesList extends StatelessWidget {
  // Constructor requiring expenses list and callback for removal
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  // List of expenses to display
  final List<Expense> expenses;

  // Callback function when an expense is removed
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    // Create a scrollable list of expenses
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => Dismissible(
        // Unique key for each expense item
        key: ValueKey(expenses[index]),
        // Red background shown when swiping to delete
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin?.horizontal ?? 16,
          ),
        ),
        // Handle swipe completion
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        // Individual expense item widget
        child: ExpenseItem(expense: expenses[index]),
      ),
    );
  }
}
