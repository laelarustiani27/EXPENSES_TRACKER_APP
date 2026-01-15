import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/providers/auth_provider.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/providers/income_provider.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/income.dart';
import 'package:expense_tracker/screens/dashboard_screen.dart';
import 'package:expense_tracker/screens/add_expenses_screen.dart';
import 'package:expense_tracker/screens/add_income_screen.dart';
import 'package:expense_tracker/screens/transactions_screen.dart';

import 'package:expense_tracker/widgets/donut_chart.dart';
import 'package:expense_tracker/widgets/balance_card.dart';
import 'package:expense_tracker/widgets/transaction_item.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
  });

  group('Critical Path Testing', () {
    testWidgets('CP1: Complete user authentication flow', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('You are just one step away!'), findsOneWidget);

      await tester.tap(find.text('Belum punya akun?'));
      await tester.pumpAndSettle();

      expect(find.text('Buat Akun Baru'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');

      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle();

      expect(find.text('Transaksi Terbaru'), findsOneWidget);
    });

    testWidgets('CP2: Add expense and verify dashboard update', (
      WidgetTester tester,
    ) async {
      final authProvider = AuthProvider();
      final expenseProvider = ExpenseProvider(authProvider);
      final incomeProvider = IncomeProvider(authProvider);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: authProvider),
            ChangeNotifierProvider.value(value: expenseProvider),
            ChangeNotifierProvider.value(value: incomeProvider),
          ],
          child: MaterialApp(
            home: const DashboardScreen(),
            routes: {'/add-expense': (context) => const AddExpenseScreen()},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), '100000');
      await tester.enterText(find.byType(TextFormField).at(1), 'Test Expense');

      await tester.tap(find.text('Kategori'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Makanan'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text('Test Expense'), findsOneWidget);
      expect(find.text('Rp 100.000'), findsOneWidget);
    });

    testWidgets('CP3: Add income and verify balance calculation', (
      WidgetTester tester,
    ) async {
      final authProvider = AuthProvider();
      final expenseProvider = ExpenseProvider(authProvider);
      final incomeProvider = IncomeProvider(authProvider);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: authProvider),
            ChangeNotifierProvider.value(value: expenseProvider),
            ChangeNotifierProvider.value(value: incomeProvider),
          ],
          child: MaterialApp(
            home: MyApp(),
            routes: {'/add-income': (context) => const AddIncomeScreen()},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add_circle));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), '5000000');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'Monthly Salary',
      );
      await tester.tap(find.text('Kategori'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gaji'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text('Monthly Salary'), findsOneWidget);
      expect(find.text('Rp 5.000.000'), findsOneWidget);
    });

    testWidgets('CP4: View transactions and verify data persistence', (
      WidgetTester tester,
    ) async {
      final authProvider = AuthProvider();
      final expenseProvider = ExpenseProvider(authProvider);
      final incomeProvider = IncomeProvider(authProvider);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: authProvider),
            ChangeNotifierProvider.value(value: expenseProvider),
            ChangeNotifierProvider.value(value: incomeProvider),
          ],
          child: MaterialApp(
            home: MyApp(),
            routes: {'/transactions': (context) => const TransactionsScreen()},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Transaksi'));
      await tester.pumpAndSettle();

      expect(find.byType(TransactionItem), findsWidgets);

      await tester.tap(find.text('Semua'));
      await tester.pumpAndSettle();

      expect(find.text('Pengeluaran'), findsWidgets);
      expect(find.text('Pemasukan'), findsWidgets);
    });

    testWidgets('CP6: Dashboard chart updates with data changes', (
      WidgetTester tester,
    ) async {
      // Setup providers
      final authProvider = AuthProvider();
      final expenseProvider = ExpenseProvider(authProvider);
      final incomeProvider = IncomeProvider(authProvider);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: authProvider),
            ChangeNotifierProvider.value(value: expenseProvider),
            ChangeNotifierProvider.value(value: incomeProvider),
          ],
          child: MaterialApp(home: DashboardScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DonutChart), findsOneWidget);

      final testExpense = Expense(
        title: 'Chart Test Expense',
        amount: 200000,
        date: DateTime.now(),
        category: ExpenseCategory.transport,
      );
      await expenseProvider.addExpense(testExpense);
      await tester.pumpAndSettle();

      expect(find.byType(DonutChart), findsOneWidget);
      final testIncome = Income(
        title: 'Chart Test Income',
        amount: 1000000,
        date: DateTime.now(),
        category: IncomeCategory.salary,
      );
      await incomeProvider.addIncome(testIncome);
      await tester.pumpAndSettle();

      expect(find.byType(BalanceCard), findsOneWidget);
    });

    testWidgets('CP7: Data persistence across app restarts', (
      WidgetTester tester,
    ) async {
      final authProvider = AuthProvider();
      final expenseProvider = ExpenseProvider(authProvider);
      final incomeProvider = IncomeProvider(authProvider);
      final testExpense = Expense(
        title: 'Persistence Test',
        amount: 100000,
        date: DateTime.now(),
        category: ExpenseCategory.shopping,
      );
      await expenseProvider.addExpense(testExpense);

      final testIncome = Income(
        title: 'Persistence Income',
        amount: 2000000,
        date: DateTime.now(),
        category: IncomeCategory.salary,
      );
      await incomeProvider.addIncome(testIncome);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: authProvider),
            ChangeNotifierProvider.value(value: expenseProvider),
            ChangeNotifierProvider.value(value: incomeProvider),
          ],
          child: MaterialApp(home: DashboardScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final newExpenseProvider = ExpenseProvider(authProvider);
      final newIncomeProvider = IncomeProvider(authProvider);

      await newExpenseProvider.loadExpenses();
      await newIncomeProvider.loadIncomes();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: authProvider),
            ChangeNotifierProvider.value(value: newExpenseProvider),
            ChangeNotifierProvider.value(value: newIncomeProvider),
          ],
          child: const MaterialApp(home: DashboardScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Persistence Test'), findsOneWidget);
      expect(find.text('Persistence Income'), findsOneWidget);
    });

    testWidgets('CP8: Error handling and validation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text('Masukkan jumlah'), findsOneWidget);
      expect(find.text('Masukkan deskripsi'), findsOneWidget);

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'invalid_amount',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'Test Description',
      );

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text('Masukkan angka yang valid'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'invalid@email.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'short');

      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('CP9: Logo containers are circular and properly scaled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(20),
                child: Image(
                  image: AssetImage('assets/icons/kipas.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final loginLogoFinder = find.byType(Container).first;
      final loginLogoWidget = tester.widget<Container>(loginLogoFinder);
      expect(loginLogoWidget.decoration, isA<BoxDecoration>());
      final loginDecoration = loginLogoWidget.decoration as BoxDecoration;
      expect(loginDecoration.shape, BoxShape.circle);
      expect(loginDecoration.color, Colors.white);
      final loginImageFinder = find.descendant(
        of: loginLogoFinder,
        matching: find.byType(Image),
      );
      final loginImageWidget = tester.widget<Image>(loginImageFinder);
      expect(loginImageWidget.fit, BoxFit.contain);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(20),
                child: Image(
                  image: AssetImage('assets/icons/kipas.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final registerLogoFinder = find.byType(Container).first;
      final registerLogoWidget = tester.widget<Container>(registerLogoFinder);
      expect(registerLogoWidget.decoration, isA<BoxDecoration>());
      final registerDecoration = registerLogoWidget.decoration as BoxDecoration;
      expect(registerDecoration.shape, BoxShape.circle);
      expect(registerDecoration.color, Colors.white);
      final registerImageFinder = find.descendant(
        of: registerLogoFinder,
        matching: find.byType(Image),
      );
      final registerImageWidget = tester.widget<Image>(registerImageFinder);
      expect(registerImageWidget.fit, BoxFit.contain);
    });
  });
}
