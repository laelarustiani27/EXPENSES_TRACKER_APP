import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/about_us_screen.dart';
import 'screens/update_information_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/add_expenses_screen.dart';
import 'screens/add_income_screen.dart';
import 'screens/transactions_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/income_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (const bool.fromEnvironment('FLUTTER_TEST')) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await initializeDateFormatting();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ExpenseProvider>(
          create:
              (context) => ExpenseProvider(
                Provider.of<AuthProvider>(context, listen: false),
              ),
        ),
        ChangeNotifierProvider<IncomeProvider>(
          create:
              (context) => IncomeProvider(
                Provider.of<AuthProvider>(context, listen: false),
              ),
        ),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Expense Tracker',
            theme: themeProvider.currentTheme,
            initialRoute: '/login',
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/dashboard': (context) => const DashboardScreen(),
              '/about-us': (context) => const AboutUsScreen(),
              '/update-info': (context) => const UpdateInformationScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/add-expense': (context) => const AddExpenseScreen(),
              '/add-income': (context) => const AddIncomeScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/transactions': (context) => const TransactionsScreen(),
            },
          );
        },
      ),
    );
  }
}
