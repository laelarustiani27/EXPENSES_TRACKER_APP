  import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/providers/auth_provider.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/providers/income_provider.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/income.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
  });

  group('Balance Update Tests', () {
    test('Balance decreases when expense is added', () async {
      final authProvider = AuthProvider();
      await authProvider.login(
        'test@example.com',
        'password123',
        balance: 1000000.0,
      );

      final expenseProvider = ExpenseProvider(authProvider);

      final initialBalance = authProvider.user!.balance;

      final expense = Expense(
        title: 'Test Expense',
        amount: 100000.0,
        date: DateTime.now(),
        category: ExpenseCategory.food,
      );

      await expenseProvider.addExpense(expense);

      final newBalance = authProvider.user!.balance;
      expect(newBalance, equals(initialBalance - 100000.0));
    });

    test('Balance increases when income is added', () async {
      final authProvider = AuthProvider();
      await authProvider.login(
        'test@example.com',
        'password123',
        balance: 1000000.0,
      );

      final incomeProvider = IncomeProvider(authProvider);

      final initialBalance = authProvider.user!.balance;

      final income = Income(
        title: 'Test Income',
        amount: 200000.0,
        date: DateTime.now(),
        category: IncomeCategory.salary,
      );

      await incomeProvider.addIncome(income);

      final newBalance = authProvider.user!.balance;
      expect(newBalance, equals(initialBalance + 200000.0));
    });

    test('Balance increases when expense is deleted', () async {
      final authProvider = AuthProvider();
      await authProvider.login(
        'test@example.com',
        'password123',
        balance: 1000000.0,
      );

      final expenseProvider = ExpenseProvider(authProvider);

      final expense = Expense(
        title: 'Test Expense',
        amount: 100000.0,
        date: DateTime.now(),
        category: ExpenseCategory.food,
      );

      await expenseProvider.addExpense(expense);
      final balanceAfterAdd = authProvider.user!.balance;

      // Delete the expense
      final expenses = expenseProvider.expenses;
      if (expenses.isNotEmpty) {
        await expenseProvider.deleteExpense(expenses.first.id!);
        final balanceAfterDelete = authProvider.user!.balance;
        expect(balanceAfterDelete, equals(balanceAfterAdd + 100000.0));
      }
    });

    test('Balance decreases when income is deleted', () async {
      final authProvider = AuthProvider();
      await authProvider.login(
        'test@example.com',
        'password123',
        balance: 1000000.0,
      );

      final incomeProvider = IncomeProvider(authProvider);

      final income = Income(
        title: 'Test Income',
        amount: 200000.0,
        date: DateTime.now(),
        category: IncomeCategory.salary,
      );

      await incomeProvider.addIncome(income);
      final balanceAfterAdd = authProvider.user!.balance;

      // Delete the income
      final incomes = incomeProvider.incomes;
      if (incomes.isNotEmpty) {
        await incomeProvider.deleteIncome(incomes.first.id!);
        final balanceAfterDelete = authProvider.user!.balance;
        expect(balanceAfterDelete, equals(balanceAfterAdd - 200000.0));
      }
    });

    test('Balance updates correctly when expense is updated', () async {
      final authProvider = AuthProvider();
      await authProvider.login(
        'test@example.com',
        'password123',
        balance: 1000000.0,
      );

      final expenseProvider = ExpenseProvider(authProvider);

      final expense = Expense(
        title: 'Test Expense',
        amount: 100000.0,
        date: DateTime.now(),
        category: ExpenseCategory.food,
      );

      await expenseProvider.addExpense(expense);
      final balanceAfterAdd = authProvider.user!.balance;

      // Update the expense amount
      final expenses = expenseProvider.expenses;
      if (expenses.isNotEmpty) {
        final updatedExpense = Expense(
          id: expenses.first.id,
          title: expenses.first.title,
          amount: 150000.0, // Increased amount
          date: expenses.first.date,
          category: expenses.first.category,
        );
        await expenseProvider.updateExpense(updatedExpense);
        final balanceAfterUpdate = authProvider.user!.balance;
        expect(
          balanceAfterUpdate,
          equals(balanceAfterAdd - 50000.0),
        ); // Additional 50k subtracted
      }
    });

    test('Balance updates correctly when income is updated', () async {
      final authProvider = AuthProvider();
      await authProvider.login(
        'test@example.com',
        'password123',
        balance: 1000000.0,
      );

      final incomeProvider = IncomeProvider(authProvider);

      final income = Income(
        title: 'Test Income',
        amount: 200000.0,
        date: DateTime.now(),
        category: IncomeCategory.salary,
      );

      await incomeProvider.addIncome(income);
      final balanceAfterAdd = authProvider.user!.balance;

      // Update the income amount
      final incomes = incomeProvider.incomes;
      if (incomes.isNotEmpty) {
        final updatedIncome = Income(
          id: incomes.first.id,
          title: incomes.first.title,
          amount: 250000.0, // Increased amount
          date: incomes.first.date,
          category: incomes.first.category,
        );
        await incomeProvider.updateIncome(updatedIncome);
        final balanceAfterUpdate = authProvider.user!.balance;
        expect(
          balanceAfterUpdate,
          equals(balanceAfterAdd + 50000.0),
        ); // Additional 50k added
      }
    });
  });
}
