import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class CircularLogo extends StatelessWidget {
  final String assetPath;
  final double size;
  final double paddingRatio; // Ubah ke ratio

  const CircularLogo({
    super.key,
    required this.assetPath,
    this.size = 100.0,
    this.paddingRatio = 0.1, // 10% dari size
  });

  @override
  Widget build(BuildContext context) {
    // Hitung padding proporsional
    final responsivePadding = size * paddingRatio;

    // Hitung shadow proporsional
    final shadowBlur = size * 0.15;
    final shadowOffset = size * 0.05;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withValues(alpha: 0.2),
            blurRadius: shadowBlur,
            offset: Offset(0, shadowOffset),
            spreadRadius: size * 0.01,
          ),
        ],
      ),
      child: ClipOval(
        child: Padding(
          padding: EdgeInsets.all(responsivePadding),
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
            // Tambahkan untuk performa
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
