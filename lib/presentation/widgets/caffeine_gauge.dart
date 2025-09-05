import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../utils/app_colors.dart';

/// Circular gauge widget for displaying caffeine intake levels
class CaffeineGauge extends StatefulWidget {
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
  State<CaffeineGauge> createState() => _CaffeineGaugeState();
}

class _CaffeineGaugeState extends State<CaffeineGauge>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _colorController;
  late Animation<double> _progressAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _valueAnimation;

  double _previousPercentage = 0.0;
  Color _previousColor = AppColors.caffeineLevel1;

  @override
  void initState() {
    super.initState();
    
    // Progress animation controller
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Color animation controller  
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Initialize with current values
    final percentage = widget.maxValue > 0 ? (widget.currentValue / widget.maxValue).clamp(0.0, 1.0) : 0.0;
    _previousPercentage = percentage;
    _previousColor = _getProgressColor(percentage);

    _setupAnimations();
    
    // Start animations on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _progressController.forward();
      _colorController.forward();
    });
  }

  void _setupAnimations() {
    final percentage = widget.maxValue > 0 ? (widget.currentValue / widget.maxValue).clamp(0.0, 1.0) : 0.0;
    final currentColor = _getProgressColor(percentage);

    // Progress animation (start from 0 on first build)
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: percentage,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubicEmphasized,
    ));

    // Value animation (start from 0 on first build)
    _valueAnimation = Tween<double>(
      begin: 0.0,
      end: widget.currentValue,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubicEmphasized,
    ));

    // Color animation
    _colorAnimation = ColorTween(
      begin: AppColors.caffeineLevel1,
      end: currentColor,
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOutCubicEmphasized,
    ));
  }

  @override
  void didUpdateWidget(CaffeineGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.currentValue != widget.currentValue || 
        oldWidget.maxValue != widget.maxValue) {
      _updateAnimations();
    }
  }

  void _updateAnimations() {
    final oldPercentage = _previousPercentage;
    final newPercentage = widget.maxValue > 0 ? (widget.currentValue / widget.maxValue).clamp(0.0, 1.0) : 0.0;
    final oldColor = _previousColor;
    final newColor = _getProgressColor(newPercentage);

    // Update progress animation
    _progressAnimation = Tween<double>(
      begin: oldPercentage,
      end: newPercentage,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.elasticOut,
    ));

    // Update value animation
    _valueAnimation = Tween<double>(
      begin: oldPercentage * widget.maxValue,
      end: widget.currentValue,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.elasticOut,
    ));

    // Update color animation if color changed
    if (oldColor != newColor) {
      _colorAnimation = ColorTween(
        begin: oldColor,
        end: newColor,
      ).animate(CurvedAnimation(
        parent: _colorController,
        curve: Curves.easeInOut,
      ));
      
      _colorController.reset();
      _colorController.forward();
      _previousColor = newColor;
    }

    _progressController.reset();
    _progressController.forward();
    _previousPercentage = newPercentage;
  }

  @override
  void dispose() {
    _progressController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_progressController, _colorController]),
      builder: (context, child) {
        final animatedPercentage = _progressAnimation.value;
        final animatedColor = _colorAnimation.value ?? _getProgressColor(animatedPercentage);
        final animatedValue = _valueAnimation.value;
        
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gauge
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CustomPaint(
                  painter: _GaugePainter(
                    percentage: animatedPercentage,
                    backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                    progressColor: animatedColor,
                    strokeWidth: 12,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${animatedValue.toInt()}',
                          style: textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: animatedColor,
                          ),
                        ),
                        Text(
                          'mg',
                          style: textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${(animatedPercentage * 100).toInt()}% of daily limit',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
              _buildStatusIndicator(animatedPercentage, textTheme, animatedColor),
              
              const SizedBox(height: 8),
              
              // Max value display
              Text(
                'Daily limit: ${widget.maxValue.toInt()}mg',
                style: textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicator(double percentage, TextTheme textTheme, Color statusColor) {
    String status;
    IconData statusIcon;

    if (percentage <= 0.5) {
      status = 'LOW';
      statusIcon = Icons.circle;
    } else if (percentage <= 0.75) {
      status = 'MODERATE';
      statusIcon = Icons.circle;
    } else if (percentage < 1.0) {
      status = 'HIGH';
      statusIcon = Icons.warning;
    } else {
      status = 'EXCESSIVE';
      statusIcon = Icons.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
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
    } else if (percentage < 1.0) {
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
