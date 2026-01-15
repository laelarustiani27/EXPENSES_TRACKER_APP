import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onRefresh;
  final VoidCallback? onCamera;
  final VoidCallback? onAddExpense;
  final VoidCallback? onAddIncome;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onRefresh,
    this.onCamera,
    this.onAddExpense,
    this.onAddIncome,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.textPrimary,
                      AppColors.textPrimary.withValues(alpha: 0.8),
                    ],
                  ).createShader(bounds),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  letterSpacing: -1,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4,
                      color: AppColors.shadow3D,
                    ),
                  ],
                ),
              ),
            ),

            Row(
              children: [
                if (onAddExpense != null)
                  _build3DIconButton(
                    icon: Icons.add_circle_outline,
                    onTap: onAddExpense!,
                  ),
                if (onAddExpense != null) const SizedBox(width: 12),

                if (onAddIncome != null)
                  _build3DIconButton(
                    icon: Icons.arrow_upward,
                    onTap: onAddIncome!,
                  ),
                if (onAddIncome != null) const SizedBox(width: 12),
                _build3DIconButton(
                  icon: Icons.help_outline,
                  onTap: onRefresh ?? () {},
                ),
                const SizedBox(width: 12),

                _build3DIconButton(icon: Icons.menu, onTap: onCamera ?? () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _build3DIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.cardBackground.withValues(alpha: 0.8),
              AppColors.cardBackground.withValues(alpha: 0.4),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.4),
              offset: const Offset(4, 4),
              blurRadius: 8,
            ),
            // Highlight atas
            BoxShadow(
              color: AppColors.highlight3D,
              offset: const Offset(-2, -2),
              blurRadius: 6,
            ),
          ],
          border: Border.all(color: AppColors.glassBorder, width: 1),
        ),
        child: Icon(
          icon,
          color: AppColors.iconPrimary,
          size: 22,
          shadows: const [
            Shadow(
              offset: Offset(0, 1),
              blurRadius: 2,
              color: AppColors.black38,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
