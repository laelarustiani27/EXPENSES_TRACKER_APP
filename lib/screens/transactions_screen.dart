import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/constants/colors.dart';
import '../models/transaction_model.dart';
import '../providers/expense_provider.dart';
import '../providers/income_provider.dart';
import '../providers/auth_provider.dart';
import '../models/expense.dart';
import '../models/income.dart';
import '../widgets/donut_chart.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with TickerProviderStateMixin {
  bool isIncomeSelected = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _showFabOptions = false;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        Provider.of<ExpenseProvider>(context, listen: false).loadExpenses();
        Provider.of<IncomeProvider>(context, listen: false).loadIncomes();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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

  String _getMonthYear(List<TransactionModel> transactions) {
    if (transactions.isEmpty) {
      return DateFormat(
        'MMM yyyy',
        'id_ID',
      ).format(DateTime.now()).toUpperCase();
    }
    final latestDate = transactions.first.date;
    return DateFormat('MMM yyyy', 'id_ID').format(latestDate).toUpperCase();
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

  void _addFunds() {
    _showAmountDialog(
      'Tambah Saldo',
      'Masukkan jumlah saldo yang ingin ditambahkan',
      (amount) async {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final success = await authProvider.addFunds(amount);
        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Saldo berhasil ditambahkan'),
                backgroundColor: AppColors.primaryRed,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  authProvider.errorMessage ?? 'Gagal menambah saldo',
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        }
      },
    );
    _toggleFabOptions();
  }

  void _withdrawFunds() {
    _showAmountDialog(
      'Tarik Saldo',
      'Masukkan jumlah saldo yang ingin ditarik',
      (amount) async {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final success = await authProvider.withdrawFunds(amount);
        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Saldo berhasil ditarik'),
                backgroundColor: AppColors.primaryRed,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  authProvider.errorMessage ?? 'Gagal menarik saldo',
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        }
      },
    );
    _toggleFabOptions();
  }

  void _showAmountDialog(String title, String hint, Function(double) onSubmit) {
    final TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title, style: TextStyle(color: AppColors.textPrimary)),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryRed),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryRed, width: 2),
              ),
            ),
            style: TextStyle(color: AppColors.textPrimary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text.trim());
                if (amount != null && amount > 0) {
                  Navigator.pop(context);
                  onSubmit(amount);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Masukkan jumlah yang valid'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, expenseProvider, _) {
        return Consumer<IncomeProvider>(
          builder: (context, incomeProvider, _) {
            final transactions = _getRecentTransactions(
              expenseProvider.expenses,
              incomeProvider.incomes,
            );
            final filteredTransactions = transactions.where(
              (t) =>
                  isIncomeSelected
                      ? t.type == TransactionType.income
                      : t.type == TransactionType.expense,
            );

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

                  SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: AppColors.textPrimary,
                                    size: 24,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Semua Transaksi',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 40),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        _buildToggleButton(),

                        const SizedBox(height: 20),

                        _buildBalanceCardWith3DChart(
                          expenseProvider.totalExpenses,
                          incomeProvider.totalIncome,
                          transactions,
                        ),

                        const SizedBox(height: 20),

                        Expanded(
                          child:
                              filteredTransactions.isEmpty
                                  ? _buildEmptyState()
                                  : FadeTransition(
                                    opacity: _fadeAnimation,
                                    child: ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: filteredTransactions.length,
                                      itemBuilder: (context, index) {
                                        return _buildTransactionItem(
                                          filteredTransactions.elementAt(index),
                                        );
                                      },
                                    ),
                                  ),
                        ),
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
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/image/nodata.png', width: 120, height: 120),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildToggleButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleOption(
              label: 'Pengeluaran',
              isSelected: !isIncomeSelected,
              onTap: () {
                setState(() {
                  isIncomeSelected = false;
                  _controller.forward(from: 0);
                });
              },
            ),
          ),
          Expanded(
            child: _buildToggleOption(
              label: 'Pemasukan',
              isSelected: isIncomeSelected,
              onTap: () {
                setState(() {
                  isIncomeSelected = true;
                  _controller.forward(from: 0);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCardWith3DChart(
    double totalExpenses,
    double totalIncome,
    List<TransactionModel> transactions,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryRed.withValues(alpha: 0.8),
            AppColors.primaryRed.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBalanceItem('Pengeluaran', totalExpenses),
                    const SizedBox(height: 20),
                    _buildBalanceItem('Pemasukan', totalIncome),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              DonutChart(size: 110),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _getMonthYear(transactions),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.calendar_today_outlined,
                color: AppColors.white,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, double amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.white.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.9),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            _formatCurrency(amount),
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(TransactionModel transaction) {
    return GestureDetector(
      onTap: () => _showTransactionOptions(transaction),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                transaction.icon,
                color: AppColors.accentRed,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_getCategoryName(transaction.category)} • ${DateFormat('dd MMM yyyy', 'id_ID').format(transaction.date)}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${transaction.type == TransactionType.income ? '+' : '-'}${_formatCurrency(transaction.amount)}',
                  style: TextStyle(
                    color:
                        transaction.type == TransactionType.income
                            ? Colors.green
                            : AppColors.primaryRed,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  transaction.type == TransactionType.income
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  color:
                      transaction.type == TransactionType.income
                          ? Colors.green
                          : AppColors.primaryRed,
                  size: 14,
                ),
              ],
            ),
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
          bottom: 330,
          right: 20,
          child: _buildFabButton(
            heroTag: 'withdraw',
            icon: Icons.account_balance_wallet,
            color: Colors.orange,
            onPressed: _withdrawFunds,
            delay: 0,
          ),
        ),

        Positioned(
          bottom: 270,
          right: 20,
          child: _buildFabButton(
            heroTag: 'addFunds',
            icon: Icons.add_circle,
            color: Colors.blue,
            onPressed: _addFunds,
            delay: 50,
          ),
        ),

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

  void _showTransactionOptions(TransactionModel transaction) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      transaction.icon,
                      color: AppColors.accentRed,
                      size: 28,
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
                        const SizedBox(height: 4),
                        Text(
                          _getCategoryName(transaction.category),
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
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _editTransaction(transaction);
                      },
                      icon: const Icon(Icons.edit, size: 20),
                      label: const Text(
                        'Ubah',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteTransaction(transaction);
                      },
                      icon: const Icon(Icons.delete_outline, size: 20),
                      label: const Text(
                        'Hapus',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cardBackground,
                        foregroundColor: AppColors.primaryRed,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _editTransaction(TransactionModel transaction) {
    if (transaction.type == TransactionType.expense) {
      Navigator.pushNamed(context, '/add-expense', arguments: transaction);
    } else {
      Navigator.pushNamed(context, '/add-income', arguments: transaction);
    }
  }

  void _deleteTransaction(TransactionModel transaction) {
    final expenseProvider = Provider.of<ExpenseProvider>(
      context,
      listen: false,
    );
    final incomeProvider = Provider.of<IncomeProvider>(context, listen: false);

    if (transaction.type == TransactionType.expense) {
      final expenseId = int.tryParse(transaction.id);
      if (expenseId != null) {
        expenseProvider.deleteExpense(expenseId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pengeluaran berhasil dihapus'),
            backgroundColor: AppColors.primaryRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  String _getCategoryName(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.food:
        return 'Makanan';
      case TransactionCategory.travel:
        return 'Perjalanan';
      case TransactionCategory.entertainment:
        return 'Hiburan';
      case TransactionCategory.shopping:
        return 'Belanja';
      case TransactionCategory.bills:
        return 'Tagihan';
      case TransactionCategory.other:
        return 'Lainnya';
    }
  }

  List<TransactionModel> _getRecentTransactions(
    List<Expense> expenses,
    List<Income> incomes,
  ) {
    List<TransactionModel> transactions = [];

    for (var expense in expenses) {
      transactions.add(
        TransactionModel(
          id: expense.id.toString(),
          category: _mapExpenseCategoryToTransactionCategory(expense.category),
          description: expense.title,
          amount: expense.amount,
          type: TransactionType.expense,
          date: expense.date,
          icon: _getExpenseIcon(expense.category),
        ),
      );
    }

    for (var income in incomes) {
      transactions.add(
        TransactionModel(
          id: income.id.toString(),
          category: _mapIncomeCategoryToTransactionCategory(income.category),
          description: income.title,
          amount: income.amount,
          type: TransactionType.income,
          date: income.date,
          icon: _getIncomeIcon(income.category),
        ),
      );
    }

    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
  }

  TransactionCategory _mapExpenseCategoryToTransactionCategory(
    ExpenseCategory category,
  ) {
    switch (category) {
      case ExpenseCategory.food:
        return TransactionCategory.food;
      case ExpenseCategory.transport:
        return TransactionCategory.travel;
      case ExpenseCategory.entertainment:
        return TransactionCategory.entertainment;
      case ExpenseCategory.shopping:
        return TransactionCategory.shopping;
      case ExpenseCategory.health:
        return TransactionCategory.bills;
      case ExpenseCategory.other:
        return TransactionCategory.other;
    }
  }

  TransactionCategory _mapIncomeCategoryToTransactionCategory(
    IncomeCategory category,
  ) {
    return TransactionCategory.other;
  }

  IconData _getExpenseIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.transport:
        return Icons.directions_car;
      case ExpenseCategory.entertainment:
        return Icons.movie;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag;
      case ExpenseCategory.health:
        return Icons.local_hospital;
      case ExpenseCategory.other:
        return Icons.more_horiz;
    }
  }

  IconData _getIncomeIcon(IncomeCategory category) {
    switch (category) {
      case IncomeCategory.salary:
        return Icons.work;
      case IncomeCategory.investment:
        return Icons.trending_up;
      case IncomeCategory.business:
        return Icons.business_center;
      case IncomeCategory.gift:
        return Icons.card_giftcard;
      case IncomeCategory.other:
        return Icons.attach_money;
    }
  }
}
