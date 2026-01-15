import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/widgets/donut_chart.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/providers/income_provider.dart';
import 'package:expense_tracker/providers/auth_provider.dart';

void main() {
  testWidgets('Donut chart renders without animation', (
    WidgetTester tester,
  ) async {
    final authProvider = AuthProvider();
    final expenseProvider = ExpenseProvider(authProvider);
    final incomeProvider = IncomeProvider(authProvider);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: expenseProvider),
          ChangeNotifierProvider.value(value: incomeProvider),
        ],
        child: MaterialApp(
          home: Scaffold(body: DonutChart(size: 200, animate: false)),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(DonutChart), findsOneWidget);
  });

  testWidgets('Donut chart renders with animation', (
    WidgetTester tester,
  ) async {
    final authProvider = AuthProvider();
    final expenseProvider = ExpenseProvider(authProvider);
    final incomeProvider = IncomeProvider(authProvider);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: expenseProvider),
          ChangeNotifierProvider.value(value: incomeProvider),
        ],
        child: MaterialApp(
          home: Scaffold(body: DonutChart(size: 200, animate: true)),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(DonutChart), findsOneWidget);
  });
}
