import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/categories_manager.dart';
import '../models/profile.dart';
import '../widgets/expenses_list.dart';
import '../widgets/new_expense.dart';
import '../widgets/chart.dart';
import '../widgets/profile_avatar.dart';
import 'profile_screen.dart';

// Main screen of the application showing expenses overview
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List to store all expenses
  final List<Expense> _expenses = [];

  // Manager for handling expense categories
  final _categoriesManager = CategoriesManager();

  // User profile instance
  late Profile _profile;

  // Flag to track first launch for profile setup
  bool _isFirstLaunch = true;

  // Check if user has completed their profile setup
  bool get _isProfileComplete {
    return _profile.name != 'User' &&
        _profile.email != 'user@example.com' &&
        _profile.monthlyBudget > 0;
  }

  @override
  void initState() {
    super.initState();
    // Initialize with default profile settings
    _profile = Profile(
      name: 'User',
      email: 'user@example.com',
      monthlyBudget: 0,
    );
  }

  // Add a new expense with budget warning if limit exceeded
  void _addExpense(Expense expense) {
    // Calculate total expenses including the new one
    final currentTotal = _expenses.fold<double>(
      0,
      (sum, e) => sum + e.amount,
    );
    final newTotalExpenses = currentTotal + expense.amount;

    // Show warning dialog if budget will be exceeded
    if (newTotalExpenses > _profile.monthlyBudget) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              const Text('Budget Exceeded'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This expense will exceed your monthly budget of ${_profile.defaultCurrency}${_profile.monthlyBudget}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Current total: ${_profile.defaultCurrency}$newTotalExpenses',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx); // Close warning dialog
                Navigator.pop(context); // Close expense sheet
                // Add the expense after navigation
                setState(() {
                  _expenses.add(expense);
                });
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Add Anyway'),
            ),
          ],
        ),
      );
    } else {
      // Add expense directly if within budget
      setState(() {
        _expenses.add(expense);
      });
      Navigator.pop(context); // Close expense sheet
    }
  }

  // Remove an expense with undo option
  void _removeExpense(Expense expense) {
    final expenseIndex = _expenses.indexOf(expense);
    setState(() {
      _expenses.remove(expense);
    });

    // Show snackbar with undo option
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _expenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  // Show bottom sheet to add new expense
  void _openAddExpenseOverlay() {
    // Check if profile setup is needed
    if (_isFirstLaunch && !_isProfileComplete) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Complete Your Profile',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Please set up your profile and monthly budget before adding expenses.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _openProfile();
              },
              child: const Text('Set Up Profile'),
            ),
          ],
        ),
      );
      return;
    }

    _isFirstLaunch = false;
    // Show bottom sheet with expense form
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
        categoriesManager: _categoriesManager,
      ),
    );
  }

  // Navigate to profile screen
  void _openProfile() async {
    final updatedProfile = await Navigator.of(context).push<Profile>(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          profile: _profile,
          onProfileUpdate: (profile) {
            setState(() {
              _profile = profile;
              _isFirstLaunch = false;
            });
            Navigator.pop(context, profile);
          },
        ),
      ),
    );

    if (updatedProfile != null) {
      setState(() {
        _profile = updatedProfile;
        _isFirstLaunch = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Calculate total expenses and remaining budget
    final totalExpenses = _expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );
    final remainingBudget = _profile.monthlyBudget - totalExpenses;
    final isOverBudget = remainingBudget < 0;

    // Show welcome screen if profile is not complete
    if (_isFirstLaunch && !_isProfileComplete) {
      return _buildWelcomeScreen(colorScheme);
    }

    // Show main expense tracking screen
    return _buildMainScreen(
        colorScheme, totalExpenses, remainingBudget, isOverBudget);
  }

  // Build the welcome screen widget
  Widget _buildWelcomeScreen(ColorScheme colorScheme) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.savings_outlined,
                  size: 120,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 32),
                Text(
                  'Welcome to\nExpense Tracker',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Take control of your finances by tracking your expenses and managing your budget effectively.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 48),
                _buildGetStartedCard(colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build the get started card widget
  Widget _buildGetStartedCard(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Complete Your Profile',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Set up your profile and monthly budget to start tracking your expenses.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _openProfile,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  // Build the main expense tracking screen
  Widget _buildMainScreen(ColorScheme colorScheme, double totalExpenses,
      double remainingBudget, bool isOverBudget) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(colorScheme),
              _buildBudgetCard(
                  colorScheme, totalExpenses, remainingBudget, isOverBudget),
              const SizedBox(height: 16),
              Expanded(
                child: _buildExpensesList(colorScheme, totalExpenses),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpenseOverlay,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Build the header section with profile
  Widget _buildHeader(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: _openProfile,
            child: ProfileAvatar(
              size: 48,
              avatarUrl: _profile.avatarUrl,
              avatarOption: _profile.avatarOption,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                Text(
                  _profile.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build the budget overview card
  Widget _buildBudgetCard(ColorScheme colorScheme, double totalExpenses,
      double remainingBudget, bool isOverBudget) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Budget',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_profile.defaultCurrency} ${_profile.monthlyBudget}',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Remaining',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_profile.defaultCurrency} ${isOverBudget ? "-" : ""}${remainingBudget.abs().toStringAsFixed(2)}',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isOverBudget
                                      ? colorScheme.error
                                      : colorScheme.primary,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: totalExpenses / _profile.monthlyBudget,
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation(
                  isOverBudget ? colorScheme.error : colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the expenses list section with chart
  Widget _buildExpensesList(ColorScheme colorScheme, double totalExpenses) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Chart(expenses: _expenses),
          ),
          Expanded(
            child: _expenses.isEmpty
                ? _buildEmptyState(colorScheme)
                : ExpensesList(
                    expenses: _expenses,
                    onRemoveExpense: _removeExpense,
                  ),
          ),
        ],
      ),
    );
  }

  // Build empty state widget when no expenses
  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No expenses yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first expense to start tracking',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
