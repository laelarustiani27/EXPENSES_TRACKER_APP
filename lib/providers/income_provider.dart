import 'package:flutter/material.dart';
import 'package:expense_tracker/database/db_provider.dart';
import 'package:expense_tracker/models/income.dart';
import 'package:expense_tracker/providers/auth_provider.dart';

class IncomeProvider extends ChangeNotifier {
  final AuthProvider authProvider;
  List<Income> _incomes = [];
  bool _isLoading = false;
  double _totalIncome = 0;
  Map<IncomeCategory, double> _incomesByCategory = {};

  IncomeProvider(this.authProvider);

  List<Income> get incomes => _incomes;
  bool get isLoading => _isLoading;
  double get totalIncome => _totalIncome;
  Map<IncomeCategory, double> get incomesByCategory => _incomesByCategory;

  Future<void> loadIncomes() async {
    if (!authProvider.isAuthenticated) {
      _incomes = [];
      _totalIncome = 0;
      _incomesByCategory = {};
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _incomes = await DbProvider.instance.queryAllIncomes();
      _totalIncome = await DbProvider.instance.incomeGetTotalIncomes();
      _incomesByCategory =
          await DbProvider.instance.incomeGetIncomesByCategory();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addIncome(Income income) async {
    try {
      await DbProvider.instance.incomeInsert(income);
      await loadIncomes();
      // Update balance: add income amount
      final newBalance = (authProvider.user?.balance ?? 0.0) + income.amount;
      await authProvider.updateProfile(balance: newBalance);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteIncome(int id) async {
    try {
      // Get the income before deleting to adjust balance
      final income = await DbProvider.instance.queryIncomeRow(id);
      if (income != null) {
        await DbProvider.instance.incomeDelete(id);
        await loadIncomes();
        // Update balance: subtract the income amount
        final newBalance = (authProvider.user?.balance ?? 0.0) - income.amount;
        await authProvider.updateProfile(balance: newBalance);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateIncome(Income income) async {
    try {
      // Get the old income to calculate balance adjustment
      if (income.id != null) {
        final oldIncome = await DbProvider.instance.queryIncomeRow(income.id!);
        await DbProvider.instance.incomeUpdate(income);
        await loadIncomes();
        if (oldIncome != null) {
          // Adjust balance: add the difference (new - old)
          final difference = income.amount - oldIncome.amount;
          final newBalance = (authProvider.user?.balance ?? 0.0) + difference;
          await authProvider.updateProfile(balance: newBalance);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteAllIncomes() async {
    try {
      // Get total incomes before deleting to adjust balance
      final totalBefore = _totalIncome;
      await DbProvider.instance.incomeDeleteAll();
      await loadIncomes();
      // Update balance: subtract the total incomes
      final newBalance = (authProvider.user?.balance ?? 0.0) - totalBefore;
      await authProvider.updateProfile(balance: newBalance);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
