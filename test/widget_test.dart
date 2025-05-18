// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/categories_manager.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/expense_item.dart';

void main() {
  group('ExpenseTrackerApp Widget Tests', () {
    testWidgets('App renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const ExpenseTrackerApp());
      expect(find.text('Expense Tracker'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });

  group('ExpenseItem Widget Tests', () {
    testWidgets('ExpenseItem displays expense details correctly',
        (WidgetTester tester) async {
      final category = ExpenseCategory(
        id: 'test-id',
        name: 'Food',
        icon: '🍔',
      );

      final expense = Expense(
        title: 'Lunch',
        amount: 15.99,
        date: DateTime(2024, 3, 15),
        category: category,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseItem(expense: expense),
          ),
        ),
      );

      expect(find.text('Lunch'), findsOneWidget);
      expect(find.text('\$15.99'), findsOneWidget);
      expect(find.text('🍔'), findsOneWidget);
      expect(find.text('FOOD'), findsOneWidget);
      expect(find.text('15/3/2024'), findsOneWidget);
    });
  });

  group('NewExpense Widget Tests', () {
    testWidgets('NewExpense form validation works',
        (WidgetTester tester) async {
      final categoriesManager = CategoriesManager();
      categoriesManager.addCategory('Food', '🍔');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewExpense(
              onAddExpense: (expense) {},
              categoriesManager: categoriesManager,
            ),
          ),
        ),
      );

      // Try to submit empty form
      await tester.tap(find.text('Save Expense'));
      await tester.pumpAndSettle();

      // Should show validation error
      expect(find.text('Invalid input'), findsOneWidget);
      expect(
        find.text(
            'Please make sure a valid title, amount, date and category was entered.'),
        findsOneWidget,
      );

      // Fill form with valid data
      await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Lunch');
      await tester.enterText(find.widgetWithText(TextField, 'Amount'), '15.99');

      // Close validation dialog
      await tester.tap(find.text('Okay'));
      await tester.pumpAndSettle();

      // Verify form fields are filled
      expect(find.text('Lunch'), findsOneWidget);
      expect(find.text('15.99'), findsOneWidget);
    });

    testWidgets('Can add new category', (WidgetTester tester) async {
      final categoriesManager = CategoriesManager();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewExpense(
              onAddExpense: (expense) {},
              categoriesManager: categoriesManager,
            ),
          ),
        ),
      );

      // Initially no categories
      expect(find.byType(DropdownButton<ExpenseCategory>), findsNothing);

      // Open add category dialog
      await tester.tap(find.text('New Category'));
      await tester.pumpAndSettle();

      expect(find.text('Add New Category'), findsOneWidget);
    });
  });
}
