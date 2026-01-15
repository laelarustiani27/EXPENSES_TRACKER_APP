import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/database/db_provider.dart';
import 'package:expense_tracker/providers/auth_provider.dart';

class ExpenseProvider extends ChangeNotifier {
  final AuthProvider authProvider;
  List<Expense> _expenses = [];
  bool _isLoading = false;
  double _totalExpenses = 0;
  Map<ExpenseCategory, double> _expensesByCategory = {};

  ExpenseProvider(this.authProvider);

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  double get totalExpenses => _totalExpenses;
  Map<ExpenseCategory, double> get expensesByCategory => _expensesByCategory;

  Future<void> loadExpenses() async {
    if (!authProvider.isAuthenticated) {
      _expenses = [];
      _totalExpenses = 0;
      _expensesByCategory = {};
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _expenses = await DbProvider.instance.queryAllExpensesRows();
      _totalExpenses = await DbProvider.instance.expenseGetTotalExpenses();
      _expensesByCategory =
          await DbProvider.instance.expenseGetExpensesByCategory();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await DbProvider.instance.expenseInsert(expense);
      await loadExpenses();
      // Update balance: subtract expense amount
      final newBalance = (authProvider.user?.balance ?? 0.0) - expense.amount;
      await authProvider.updateProfile(balance: newBalance);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      // Get the expense before deleting to adjust balance
      final expense = await DbProvider.instance.queryRow(id);
      if (expense != null) {
        await DbProvider.instance.expenseDelete(id);
        await loadExpenses();
        // Update balance: add back the expense amount
        final newBalance = (authProvider.user?.balance ?? 0.0) + expense.amount;
        await authProvider.updateProfile(balance: newBalance);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      // Get the old expense to calculate balance adjustment
      if (expense.id != null) {
        final oldExpense = await DbProvider.instance.queryRow(expense.id!);
        await DbProvider.instance.expenseUpdate(expense);
        await loadExpenses();
        if (oldExpense != null) {
          // Adjust balance: subtract the difference (new - old)
          final difference = expense.amount - oldExpense.amount;
          final newBalance = (authProvider.user?.balance ?? 0.0) - difference;
          await authProvider.updateProfile(balance: newBalance);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Map<DateTime, double> getWeeklyExpenses() {
    final now = DateTime.now();
    final Map<DateTime, double> weeklyExpenses = {};

    for (int i = 0; i <= 6; i++) {
      final date = DateTime(now.year, now.month, now.day - i);
      weeklyExpenses[date] = 0;
    }

    for (final expense in _expenses) {
      final expenseDate = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );

      if (now.difference(expenseDate).inDays <= 6) {
        weeklyExpenses.update(
          expenseDate,
          (value) => value + expense.amount,
          ifAbsent: () => expense.amount,
        );
      }
    }

    return weeklyExpenses;
  }

  Future<void> deleteAllExpenses() async {
    try {
      // Get total expenses before deleting to adjust balance
      final totalBefore = _totalExpenses;
      await DbProvider.instance.expenseDeleteAll();
      await loadExpenses();
      // Update balance: add back the total expenses
      final newBalance = (authProvider.user?.balance ?? 0.0) + totalBefore;
      await authProvider.updateProfile(balance: newBalance);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
