# Expense Tracker App

A beautiful and functional expense tracker application built with Flutter. This app helps you track your daily expenses across different categories and visualizes your spending patterns.

## Features

- Add, view, and delete expenses
- Categorize expenses (Food, Travel, Leisure, Work)
- View expenses in a beautiful chart
- Swipe to delete expenses
- Form validation
- Dark mode support

## Getting Started

1. Make sure you have Flutter installed on your machine. If not, follow the [official installation guide](https://flutter.dev/docs/get-started/install).

2. Clone this repository:
```bash
git clone <your-repository-url>
```

3. Navigate to the project directory:
```bash
cd expense_tracker
```

4. Get the dependencies:
```bash
flutter pub get
```

5. Run the app:
```bash
flutter run
```

## Dependencies

- flutter: The UI framework
- intl: For date formatting
- uuid: For generating unique IDs
- fl_chart: For creating beautiful charts

## Project Structure

```
lib/
  ├── models/
  │   └── expense.dart
  ├── widgets/
  │   ├── chart.dart
  │   ├── expense_item.dart
  │   ├── expenses_list.dart
  │   └── new_expense.dart
  ├── screens/
  │   └── home_screen.dart
  └── main.dart
```

## Contributing

Feel free to submit issues and enhancement requests! 