import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../utils/app_colors.dart';

/// Circular gauge widget for displaying caffeine intake levels
class CaffeineGauge extends StatelessWidget {
  final double currentValue;
  final double maxValue;
  final double size;

  const CaffeineGauge({
    super.key,
    required this.currentValue,
    required this.maxValue,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = maxValue > 0 ? (currentValue / maxValue).clamp(0.0, 1.0) : 0.0;
    final textTheme = Theme.of(context).textTheme;
    
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gauge
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _GaugePainter(
                percentage: percentage,
                backgroundColor: AppColors.grey200,
                progressColor: _getProgressColor(percentage),
                strokeWidth: 12,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${currentValue.toInt()}',
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getProgressColor(percentage),
                      ),
                    ),
                    Text(
                      'mg',
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.grey600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(percentage * 100).toInt()}% of daily limit',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Status indicator
          _buildStatusIndicator(percentage, textTheme),
          
          const SizedBox(height: 8),
          
          // Max value display
          Text(
            'Daily limit: ${maxValue.toInt()}mg',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(double percentage, TextTheme textTheme) {
    String status;
    Color statusColor;
    IconData statusIcon;

    if (percentage <= 0.5) {
      status = 'LOW';
      statusColor = AppColors.caffeineLevel1;
      statusIcon = Icons.circle;
    } else if (percentage <= 0.75) {
      status = 'MODERATE';
      statusColor = AppColors.caffeineLevel2;
      statusIcon = Icons.circle;
    } else if (percentage <= 1.0) {
      status = 'HIGH';
      statusColor = AppColors.caffeineLevel3;
      statusIcon = Icons.warning;
    } else {
      status = 'EXCESSIVE';
      statusColor = AppColors.caffeineLevel4;
      statusIcon = Icons.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 16,
            color: statusColor,
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: textTheme.labelMedium?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage <= 0.5) {
      return AppColors.caffeineLevel1;
    } else if (percentage <= 0.75) {
      return AppColors.caffeineLevel2;
    } else if (percentage <= 1.0) {
      return AppColors.caffeineLevel3;
    } else {
      return AppColors.caffeineLevel4;
    }
  }
}

class _GaugePainter extends CustomPainter {
  final double percentage;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  _GaugePainter({
    required this.percentage,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    if (percentage > 0) {
      const startAngle = -math.pi / 2; // Start from top
      final sweepAngle = 2 * math.pi * percentage;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _GaugePainter &&
           (oldDelegate.percentage != percentage ||
            oldDelegate.progressColor != progressColor);
  }
}
