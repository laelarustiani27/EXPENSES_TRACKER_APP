import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../core/constants/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Image.asset(
            'assets/image/nodata.png',
            width: 250,
            height: 250,
          ),
        ),
      );
    }

    final double monthlyExpense = user.monthlyExpense;
    final double monthlyIncome = user.monthlyIncome;
    final double remainingBalance = monthlyIncome - monthlyExpense;
    final double expensePercentage =
        monthlyIncome == 0 ? 0 : (monthlyExpense / monthlyIncome) * 100;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryRed.withValues(alpha: 0.4),
                    AppColors.accentRed.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -200,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryRed.withValues(alpha: 0.5),
                    AppColors.accentRed.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.2),
                                Colors.white.withValues(alpha: 0.05),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.2,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                _buildInfoRow(
                                  icon: Icons.account_balance_wallet,
                                  label: 'Total Saldo',
                                  value:
                                      'Rp ${user.balance.toStringAsFixed(0)}',
                                ),
                                const SizedBox(height: 20),
                                _buildInfoRow(
                                  icon: Icons.trending_up,
                                  label: 'Pendapatan Bulanan',
                                  value:
                                      'Rp ${monthlyIncome.toStringAsFixed(0)}',
                                ),
                                const SizedBox(height: 20),
                                _buildInfoRow(
                                  icon: Icons.trending_down,
                                  label: 'Pengeluaran Bulanan',
                                  value:
                                      'Rp ${monthlyExpense.toStringAsFixed(0)}',
                                ),
                                const SizedBox(height: 20),
                                _buildInfoRow(
                                  icon: Icons.savings,
                                  label: 'Sisa Saldo Bulanan',
                                  value:
                                      'Rp ${remainingBalance.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
                                  valueColor:
                                      remainingBalance >= 0
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                ),
                                const SizedBox(height: 20),
                                _buildInfoRow(
                                  icon: Icons.pie_chart_outline,
                                  label: 'Persentase Pengeluaran',
                                  value:
                                      '${expensePercentage.toStringAsFixed(1)}%',
                                  valueColor:
                                      expensePercentage > 70
                                          ? Colors.redAccent
                                          : Colors.orangeAccent,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Center(
                    child: Container(
                      width: 140,
                      height: 5,
                      margin: const EdgeInsets.only(top: 32),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white.withValues(alpha: 0.8),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  color: valueColor ?? Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
