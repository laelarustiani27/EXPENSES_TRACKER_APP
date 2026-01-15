import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/constants/colors.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_item.dart';
import '../widgets/circular_logo.dart';
import '../models/transaction_model.dart';
import '../providers/expense_provider.dart';
import '../providers/income_provider.dart';
import '../providers/auth_provider.dart';
import '../models/expense.dart';
import '../models/income.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fabController;
  bool _showFabOptions = false;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        final expenseProvider = Provider.of<ExpenseProvider>(
          context,
          listen: false,
        );
        final incomeProvider = Provider.of<IncomeProvider>(
          context,
          listen: false,
        );
        expenseProvider.loadExpenses();
        incomeProvider.loadIncomes();
      }
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  void _handleAboutUs() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Tentang Kami',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Finance Tracker App',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Aplikasi ini membantu Anda mengelola keuangan dengan mudah dan efisien.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Fitur:',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildFeatureItem('• Catat pengeluaran dan pemasukan'),
                _buildFeatureItem('• Lihat laporan keuangan'),
                _buildFeatureItem('• Atur kategori transaksi'),
                _buildFeatureItem('• Kelola budget bulanan'),
                const SizedBox(height: 16),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: AppColors.primaryRed,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
    );
  }

  void _handleSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  void _handleCamera() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Fitur kamera untuk scan struk belanja'),
        backgroundColor: AppColors.primaryRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    _toggleFabOptions();
  }

  void _toggleFabOptions() {
    setState(() {
      _showFabOptions = !_showFabOptions;
      if (_showFabOptions) {
        _fabController.forward();
      } else {
        _fabController.reverse();
      }
    });
  }

  void _addExpense() {
    Navigator.pushNamed(context, '/add-expense');
    _toggleFabOptions();
  }

  void _addIncome() {
    Navigator.pushNamed(context, '/add-income');
    _toggleFabOptions();
  }

  void _deleteTransaction(
    TransactionModel transaction,
    ExpenseProvider expenseProvider,
    IncomeProvider incomeProvider,
  ) {
    if (transaction.type == TransactionType.expense) {
      final expenseId = int.tryParse(transaction.id);
      if (expenseId != null) {
        expenseProvider.deleteExpense(expenseId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pengeluaran berhasil dihapus'),
            backgroundColor: AppColors.primaryRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      final incomeId = int.tryParse(transaction.id);
      if (incomeId != null) {
        incomeProvider.deleteIncome(incomeId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pemasukan berhasil dihapus'),
            backgroundColor: AppColors.primaryRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _editTransaction(TransactionModel transaction) {
    if (transaction.type == TransactionType.expense) {
      Navigator.pushNamed(context, '/add-expense', arguments: transaction);
    } else {
      Navigator.pushNamed(context, '/add-income', arguments: transaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Redirect to login if not authenticated
        if (!authProvider.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Consumer<ExpenseProvider>(
          builder: (context, expenseProvider, _) {
            return Consumer<IncomeProvider>(
              builder: (context, incomeProvider, _) {
                final transactions = _getRecentTransactions(
                  expenseProvider.expenses,
                  incomeProvider.incomes,
                );
                final userBalance = authProvider.user?.balance ?? 0.0;
                final totalSpent = expenseProvider.totalExpenses;
                final totalEarned = incomeProvider.totalIncome;

                return Scaffold(
                  backgroundColor: AppColors.background,
                  body: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.topRight,
                              radius: 1.5,
                              colors: [
                                AppColors.primaryRed.withValues(alpha: 0.1),
                                AppColors.background,
                              ],
                            ),
                          ),
                        ),
                      ),

                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircularLogo(
                                      assetPath: 'assets/icons/logokipas.png',
                                      size: 60.0,
                                    ),

                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.help_outline,
                                            color: AppColors.textPrimary,
                                            size: 28,
                                          ),
                                          onPressed: _handleAboutUs,
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: Icon(
                                            Icons.settings,
                                            color: AppColors.textPrimary,
                                            size: 28,
                                          ),
                                          onPressed: _handleSettings,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            BalanceCard(
                              availableBalance: userBalance,
                              spent: totalSpent,
                              earned: totalEarned,
                            ),
                            const SizedBox(height: 36),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: _buildSectionHeader(context),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child:
                                  transactions.isEmpty
                                      ? _buildEmptyState()
                                      : ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            transactions.length > 4
                                                ? 4
                                                : transactions.length,
                                        itemBuilder: (context, index) {
                                          return TransactionItem(
                                            transaction: transactions[index],
                                            index: index,
                                            onTap:
                                                () => _handleTransactionTap(
                                                  transactions[index],
                                                ),
                                            onDelete:
                                                () => _deleteTransaction(
                                                  transactions[index],
                                                  expenseProvider,
                                                  incomeProvider,
                                                ),
                                            onEdit:
                                                () => _editTransaction(
                                                  transactions[index],
                                                ),
                                          );
                                        },
                                      ),
                            ),
                            const SizedBox(height: 140),
                          ],
                        ),
                      ),

                      if (_showFabOptions)
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: _toggleFabOptions,
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.7),
                            ),
                          ),
                        ),

                      if (_showFabOptions) _buildFabOptions(),
                      _buildMainFab(),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Opacity(
              opacity: 0.7,
              child: Image.asset(
                'assets/image/nodata.png',
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMainFab() {
    return Positioned(
      bottom: 30,
      right: 20,
      child: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          heroTag: 'main',
          onPressed: _toggleFabOptions,
          backgroundColor: AppColors.primaryRed,
          elevation: 8,
          child: AnimatedRotation(
            turns: _showFabOptions ? 0.125 : 0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              _showFabOptions ? Icons.close : Icons.add,
              color: AppColors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFabOptions() {
    return Stack(
      children: [
        Positioned(
          bottom: 210,
          right: 20,
          child: _buildFabButton(
            heroTag: 'camera',
            icon: Icons.camera_alt,
            color: AppColors.primaryRed,
            onPressed: _handleCamera,
            delay: 100,
          ),
        ),

        Positioned(
          bottom: 150,
          right: 20,
          child: _buildFabButton(
            heroTag: 'expense',
            icon: Icons.arrow_upward,
            color: AppColors.primaryRed.withValues(alpha: 0.8),
            onPressed: _addExpense,
            delay: 150,
          ),
        ),

        Positioned(
          bottom: 90,
          right: 20,
          child: _buildFabButton(
            heroTag: 'income',
            icon: Icons.arrow_downward,
            color: Colors.green,
            onPressed: _addIncome,
            delay: 200,
          ),
        ),
      ],
    );
  }

  Widget _buildFabButton({
    required String heroTag,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: _showFabOptions ? 1.0 : 0.0),
      duration: Duration(milliseconds: 300 + delay),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: clampedValue,
          child: Opacity(
            opacity: clampedValue,
            child: SizedBox(
              width: 56,
              height: 56,
              child: FloatingActionButton(
                heroTag: heroTag,
                onPressed: onPressed,
                backgroundColor: color,
                elevation: 8,
                child: Icon(icon, color: AppColors.white, size: 28),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Transaksi Terbaru',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 3,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.accentRed,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/transactions'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryRed.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleTransactionTap(TransactionModel transaction) {
    final expenseProvider = Provider.of<ExpenseProvider>(
      context,
      listen: false,
    );
    final incomeProvider = Provider.of<IncomeProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      transaction.icon,
                      color: AppColors.primaryRed,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.description,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          transaction.category.toString().split('.').last,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${transaction.type == TransactionType.income ? '+' : '-'}${_formatCurrency(transaction.amount)}',
                    style: TextStyle(
                      color:
                          transaction.type == TransactionType.income
                              ? Colors.green
                              : AppColors.primaryRed,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _editTransaction(transaction);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Ubah'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteTransaction(
                          transaction,
                          expenseProvider,
                          incomeProvider,
                        );
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Hapus'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cardBackground,
                        foregroundColor: AppColors.primaryRed,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<TransactionModel> _getRecentTransactions(
    List<Expense> expenses,
    List<Income> incomes,
  ) {
    final List<TransactionModel> transactions = [];

    for (final expense in expenses) {
      transactions.add(
        TransactionModel(
          id: expense.id.toString(),
          category: TransactionCategory.other,
          description: expense.title,
          amount: expense.amount,
          type: TransactionType.expense,
          date: expense.date,
          icon: Icons.shopping_cart,
        ),
      );
    }

    for (final income in incomes) {
      transactions.add(
        TransactionModel(
          id: income.id.toString(),
          category: TransactionCategory.other,
          description: income.title,
          amount: income.amount,
          type: TransactionType.income,
          date: income.date,
          icon: Icons.attach_money,
        ),
      );
    }

    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
  }
}
