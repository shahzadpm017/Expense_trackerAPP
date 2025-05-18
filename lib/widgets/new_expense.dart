import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../models/categories_manager.dart';
import 'add_category_dialog.dart';

// Widget that provides a form to add new expenses
class NewExpense extends StatefulWidget {
  // Constructor requiring callback and categories manager
  const NewExpense({
    super.key,
    required this.onAddExpense,
    required this.categoriesManager,
  });

  // Callback function when a new expense is added
  final void Function(Expense expense) onAddExpense;

  // Manager for handling expense categories
  final CategoriesManager categoriesManager;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  // Controllers for form input fields
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  // Selected date for the expense
  DateTime? _selectedDate;

  // Selected category for the expense
  ExpenseCategory? _selectedCategory;

  // Date formatter for displaying dates
  final _formatter = DateFormat.yMd();

  @override
  void initState() {
    super.initState();
    // Set default category if available
    if (widget.categoriesManager.categories.isNotEmpty) {
      _selectedCategory = widget.categoriesManager.categories.first;
    }
  }

  // Show date picker dialog
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  // Show dialog to add a new category
  void _showAddCategoryDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => const AddCategoryDialog(),
    );

    if (result != null) {
      widget.categoriesManager.addCategory(result['name']!, result['icon']!);
      setState(() {
        _selectedCategory = widget.categoriesManager.categories.last;
      });
    }
  }

  // Validate and submit the expense data
  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    // Show error dialog if any field is invalid
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null ||
        _selectedCategory == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
            'Please make sure a valid title, amount, date and category was entered.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    // Create and submit new expense
    final newExpense = Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory!,
    );

    widget.onAddExpense(newExpense);
  }

  @override
  void dispose() {
    // Clean up controllers
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.categoriesManager.categories;
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
        child: Column(
          children: [
            // Title input field
            TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Title'),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                // Amount input field
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixText: '₹ ',
                      label: Text('Amount'),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Date picker field
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'No date'
                                : _formatter.format(_selectedDate!),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_month, size: 20),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Category selector and actions
            SizedBox(
              width: width,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  // Category dropdown
                  if (categories.isNotEmpty)
                    Container(
                      constraints: BoxConstraints(maxWidth: width * 0.4),
                      child: DropdownButton<ExpenseCategory>(
                        isExpanded: true,
                        value: _selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                Text(category.icon),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    category.name.toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                    ),
                  // Add new category button
                  TextButton.icon(
                    onPressed: _showAddCategoryDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  // Action buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Cancel button
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      // Save button
                      FilledButton(
                        onPressed: _submitExpenseData,
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
