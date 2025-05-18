import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

// Widget that displays a beautiful animated bar chart of daily expenses
class Chart extends StatefulWidget {
  // Constructor requiring list of expenses
  const Chart({super.key, required this.expenses});

  // List of expenses to visualize
  final List<Expense> expenses;

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> with SingleTickerProviderStateMixin {
  // Animation controller for bar chart animation
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller with 1-second duration
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Calculate daily expenses for the last 7 days
  List<DailyExpense> get dailyExpenses {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final groupedExpenses = <DateTime, double>{};

    // Pre-fill all 7 days with 0
    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: i));
      groupedExpenses[date] = 0;
    }

    // Add actual expenses
    for (final expense in widget.expenses) {
      final date = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      if (date.isAfter(today.subtract(const Duration(days: 7))) &&
          !date.isAfter(today)) {
        groupedExpenses[date] = (groupedExpenses[date] ?? 0) + expense.amount;
      }
    }

    // Convert to list and sort by date
    return groupedExpenses.entries
        .map((entry) => DailyExpense(date: entry.key, amount: entry.value))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // Get the highest daily expense amount (used for scaling bars)
  double get maxExpense {
    final max = dailyExpenses.fold<double>(
      0,
      (max, expense) => expense.amount > max ? expense.amount : max,
    );
    return max > 0 ? max : 1;
  }

  // Calculate total expenses for all days
  double get totalExpenses {
    return widget.expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dateFormatter = DateFormat.E();
    final expenses = dailyExpenses;

    // Show empty state if no expenses
    if (totalExpenses == 0) {
      return Card(
        elevation: 8,
        shadowColor: colorScheme.primary.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chart header with title and total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spending Trend',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Last 7 Days',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  // Total amount badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      totalExpenses >= 10000
                          ? '${(totalExpenses / 1000).toStringAsFixed(1)}k'
                          : '₹${totalExpenses.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Bar chart section
              SizedBox(
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: expenses.map((expense) {
                    final isToday = expense.date.day == DateTime.now().day;
                    final barHeight = expense.amount / maxExpense;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Animated bar with amount
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Column(
                                  children: [
                                    // Show amount if greater than 0
                                    if (expense.amount > 0)
                                      Text(
                                        expense.amount >= 10000
                                            ? '${(expense.amount / 1000).toStringAsFixed(1)}k'
                                            : '₹${expense.amount.toStringAsFixed(0)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: isToday
                                                  ? colorScheme.primary
                                                  : colorScheme
                                                      .onSurfaceVariant,
                                              fontWeight: isToday
                                                  ? FontWeight.bold
                                                  : null,
                                              fontSize: expense.amount >= 10000
                                                  ? 10
                                                  : 12,
                                            ),
                                      ),
                                    const SizedBox(height: 8),
                                    // Animated bar with gradient
                                    Container(
                                      height: 150 *
                                          barHeight *
                                          _animationController.value,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            colorScheme.primary,
                                            colorScheme.primary
                                                .withOpacity(0.5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            // Day label
                            Text(
                              dateFormatter.format(expense.date),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isToday
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                                    fontWeight:
                                        isToday ? FontWeight.bold : null,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 8,
      shadowColor: colorScheme.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spending Trend',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last 7 Days',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    totalExpenses >= 10000
                        ? '${(totalExpenses / 1000).toStringAsFixed(1)}k'
                        : '₹${totalExpenses.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: expenses.map((expense) {
                  final isToday = expense.date.day == DateTime.now().day;
                  final barHeight = expense.amount / maxExpense;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Column(
                                children: [
                                  if (expense.amount > 0)
                                    Text(
                                      expense.amount >= 10000
                                          ? '${(expense.amount / 1000).toStringAsFixed(1)}k'
                                          : '₹${expense.amount.toStringAsFixed(0)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: isToday
                                                ? colorScheme.primary
                                                : colorScheme.onSurfaceVariant,
                                            fontWeight: isToday
                                                ? FontWeight.bold
                                                : null,
                                            fontSize: expense.amount >= 10000
                                                ? 10
                                                : 12,
                                          ),
                                    ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 150 *
                                        barHeight *
                                        _animationController.value,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          isToday
                                              ? colorScheme.primary
                                              : colorScheme.secondary,
                                          isToday
                                              ? colorScheme.primary
                                                  .withOpacity(0.7)
                                              : colorScheme.secondary
                                                  .withOpacity(0.7),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (isToday
                                                  ? colorScheme.primary
                                                  : colorScheme.secondary)
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dateFormatter.format(expense.date),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: isToday
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                  fontWeight: isToday ? FontWeight.bold : null,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class to store daily expense data
class DailyExpense {
  const DailyExpense({required this.date, required this.amount});
  final DateTime date;
  final double amount;
}
