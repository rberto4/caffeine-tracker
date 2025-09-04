import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'drink_icon.dart';

/// Widget che gestisce l'animazione del volo dell'icona dalla quick add al gauge
class DrinkToGaugeAnimation extends StatefulWidget {
  final String productName;
  final double caffeineAmount;
  final Offset startPosition;
  final Offset endPosition;
  final VoidCallback onComplete;
  final Color drinkColor;

  const DrinkToGaugeAnimation({
    super.key,
    required this.productName,
    required this.caffeineAmount,
    required this.startPosition,
    required this.endPosition,
    required this.onComplete,
    required this.drinkColor,
  });

  @override
  State<DrinkToGaugeAnimation> createState() => _DrinkToGaugeAnimationState();
}

class _DrinkToGaugeAnimationState extends State<DrinkToGaugeAnimation>
    with TickerProviderStateMixin {
  late AnimationController _flyController;
  late AnimationController _explosionController;
  
  late Animation<Offset> _flyAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _explosionAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animazione del volo dell'icona
    _flyController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Animazione dell'esplosione
    _explosionController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _setupAnimations();
    _startAnimation();
  }

  void _setupAnimations() {
    // Curva del volo parabolico con effetto di gravità
    _flyAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: widget.startPosition,
          end: Offset(
            widget.startPosition.dx + (widget.endPosition.dx - widget.startPosition.dx) * 0.7,
            widget.startPosition.dy - 50, // Arco verso l'alto
          ),
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(
            widget.startPosition.dx + (widget.endPosition.dx - widget.startPosition.dx) * 0.7,
            widget.startPosition.dy - 50,
          ),
          end: widget.endPosition,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _flyController,
      curve: Curves.easeInOut,
    ));

    // Scala dell'icona durante il volo
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _flyController,
      curve: Curves.easeInOut,
    ));

    // Rotazione dell'icona
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _flyController,
      curve: Curves.easeInOut,
    ));

    // Animazione esplosione
    _explosionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _explosionController,
      curve: Curves.easeOut,
    ));
  }

  Future<void> _startAnimation() async {
    // 1. Volo dell'icona
    await _flyController.forward();
    
    // 2. Esplosione
    await _explosionController.forward();
    
    // Completa l'animazione
    widget.onComplete();
  }

  @override
  void dispose() {
    _flyController.dispose();
    _explosionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _flyController,
        _explosionController,
      ]),
      builder: (context, child) {
        return Stack(
          children: [
            // Icona volante
            if (_flyController.value < 1.0)
              Positioned(
                left: _flyAnimation.value.dx - 24, // Centro l'icona
                top: _flyAnimation.value.dy - 24,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: DrinkIcon(
                      productName: widget.productName,
                      size: 48,
                      showBackground: true,
                      backgroundColor: widget.drinkColor.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),

            // Effetto esplosione
            if (_explosionController.value > 0)
              Positioned(
                left: widget.endPosition.dx - 100, // Aumento ulteriormente da -75 a -100
                top: widget.endPosition.dy - 100,
                child: _buildExplosionEffect(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildExplosionEffect() {
    return SizedBox(
      width: 200, // Aumento ulteriormente da 150 a 200
      height: 200,
      child: CustomPaint(
        painter: ExplosionPainter(
          progress: _explosionAnimation.value,
          color: widget.drinkColor,
        ),
      ),
    );
  }
}

/// Painter per l'effetto esplosione
class ExplosionPainter extends CustomPainter {
  final double progress;
  final Color color;

  ExplosionPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 1.0 - progress)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final particleCount = 12;

    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * math.pi;
      final distance = progress * 80; // Aumento ulteriormente da 60 a 80
      final particleSize = (1.0 - progress) * 8; // Aumento da 6 a 8

      final x = center.dx + math.cos(angle) * distance;
      final y = center.dy + math.sin(angle) * distance;

      canvas.drawCircle(
        Offset(x, y),
        particleSize,
        paint,
      );
    }

    // Cerchio centrale che si espande
    final centralPaint = Paint()
      ..color = color.withValues(alpha: (1.0 - progress) * 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      progress * 70, // Aumento ulteriormente da 50 a 70
      centralPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
