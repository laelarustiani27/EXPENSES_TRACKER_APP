import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../core/constants/colors.dart';
import '../models/transaction_model.dart';

class TransactionItem extends StatefulWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final int index;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
    this.onEdit,
    this.index = 0,
  });

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _controller.value,
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) {
                  setState(() => _isPressed = false);
                  widget.onTap?.call();
                },
                onTapCancel: () => setState(() => _isPressed = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(bottom: 12),
                  transform:
                      Matrix4.identity()
                        ..setTranslationRaw(0.0, _isPressed ? 2.0 : 0.0, 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow:
                        _isPressed
                            ? [
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: 0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 8,
                              ),
                            ]
                            : [
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: 0.4),
                                offset: const Offset(0, 6),
                                blurRadius: 12,
                                spreadRadius: -2,
                              ),
                              BoxShadow(
                                color: AppColors.primaryRed.withValues(
                                  alpha: 0.2,
                                ),
                                offset: const Offset(0, 3),
                                blurRadius: 8,
                                spreadRadius: -1,
                              ),
                            ],
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryRed,
                        AppColors.primaryRedDark,
                        AppColors.darkRed,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.black.withValues(alpha: 0.3),
                          ),
                          child: Icon(
                            widget.transaction.icon,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.transaction.description,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                widget.transaction.category
                                    .toString()
                                    .split('.')
                                    .last,
                                style: const TextStyle(
                                  color: AppColors.lightPink,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Text(
                          '${widget.transaction.type == TransactionType.income ? '+' : '-'}${_formatCurrency(widget.transaction.amount)}',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
