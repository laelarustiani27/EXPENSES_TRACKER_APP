import 'dart:core';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/income_provider.dart';

class DonutChart extends StatefulWidget {
  final double size;
  final bool animate;

  const DonutChart({super.key, this.size = 120, this.animate = true});

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double? _previousSpent;
  double? _previousEarned;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final expenseProvider = Provider.of<ExpenseProvider>(
      context,
      listen: false,
    );
    final incomeProvider = Provider.of<IncomeProvider>(context, listen: false);
    final currentSpent = expenseProvider.totalExpenses;
    final currentEarned = incomeProvider.totalIncome;

    if (_previousSpent != null &&
        _previousEarned != null &&
        (_previousSpent != currentSpent || _previousEarned != currentEarned) &&
        !_controller.isAnimating) {
      _controller.reset();
      _controller.forward();
    }

    _previousSpent = currentSpent;
    _previousEarned = currentEarned;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final incomeProvider = Provider.of<IncomeProvider>(context);

    final spent = expenseProvider.totalExpenses;
    final earned = incomeProvider.totalIncome;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(0.1 * math.sin(_animation.value * math.pi))
                ..rotateY(0.1 * math.cos(_animation.value * math.pi)),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withAlpha(77), // 0.3 opacity
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: -5,
                ),
                BoxShadow(
                  color: const Color(0xFFE8B4B8).withAlpha(102), // 0.4 opacity
                  blurRadius: 15,
                  offset: const Offset(-5, -5),
                ),
              ],
            ),
            child: CustomPaint(
              painter: DonutChartPainter(
                spent: spent,
                earned: earned,
                progress: widget.animate ? _animation.value : 1.0,
              ),
            ),
          ),
        );
      },
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final double spent;
  final double earned;
  final double progress;

  const DonutChartPainter({
    required this.spent,
    required this.earned,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = radius * 0.35;

    final total = spent + earned;
    final spentAngle =
        total == 0 ? 0.0 : (spent / total) * 2 * math.pi * progress;
    final earnedAngle =
        total == 0 ? 0.0 : (earned / total) * 2 * math.pi * progress;

    final bgPaint =
        Paint()
          ..color = const Color(0xFF4A1F23)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    for (int i = 3; i >= 0; i--) {
      final layerPaint =
          Paint()
            ..shader = LinearGradient(
              colors: [
                Color.lerp(
                  const Color(0xFFE8B4B8),
                  const Color(0xFF000000),
                  i * 0.1,
                )!.withAlpha(153), 
                Color.lerp(
                  const Color(0xFFD89BA0),
                  const Color(0xFF000000),
                  i * 0.1,
                )!,
              ],
            ).createShader(Rect.fromCircle(center: center, radius: radius))
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(center.dx, center.dy + i * 0.5),
          radius: radius - strokeWidth / 2,
        ),
        -math.pi / 2,
        spentAngle,
        false,
        layerPaint,
      );
    }

    for (int i = 3; i >= 0; i--) {
      final layerPaint =
          Paint()
            ..shader = LinearGradient(
              colors: [
                Color.lerp(
                  const Color.fromARGB(255, 192, 54, 66),
                  const Color(0xFF000000),
                  i * 0.1,
                )!,
                Color.lerp(
                  const Color(0xFFE8B4B8),
                  const Color(0xFF000000),
                  i * 0.1,
                )!,
              ],
            ).createShader(Rect.fromCircle(center: center, radius: radius))
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(center.dx, center.dy + i * 0.5),
          radius: radius - strokeWidth / 2,
        ),
        -math.pi / 2 + spentAngle,
        earnedAngle,
        false,
        layerPaint,
      );
    }

    final innerCirclePaint =
        Paint()
          ..shader = RadialGradient(
            colors: [const Color(0xFF5A2328), const Color(0xFF3A1418)],
            stops: const [0.3, 1.0],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius - strokeWidth, innerCirclePaint);

    final highlightPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFFFFFFF).withAlpha(26), 
              const Color(0x00FFFFFF),
            ],
            stops: const [0.0, 0.6],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx - radius * 0.2, center.dy - radius * 0.2),
      radius * 0.4,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(DonutChartPainter oldDelegate) {
    return oldDelegate.spent != spent ||
        oldDelegate.earned != earned ||
        oldDelegate.progress != progress;
  }
}
