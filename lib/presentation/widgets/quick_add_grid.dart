import 'package:caffeine_tracker/presentation/screens/other_intakes_screen.dart';
import 'package:caffeine_tracker/presentation/widgets/box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/beverage_provider.dart';
import '../../domain/providers/intake_provider.dart';
import '../../domain/models/intake.dart';
import '../../domain/models/beverage.dart';
import '../../utils/app_colors.dart';
import '../../utils/animation_overlay_service.dart';

/// Grid showing quick add buttons for default beverages
class QuickAddGrid extends StatefulWidget {
  final GlobalKey? gaugeKey;

  const QuickAddGrid({super.key, this.gaugeKey});

  @override
  State<QuickAddGrid> createState() => _QuickAddGridState();
}

class _QuickAddGridState extends State<QuickAddGrid>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<GlobalKey> _buttonKeys;
  bool _isAnimationInProgress = false;

  @override
  void initState() {
    super.initState();

    const quickProductsCount = 4; // Number of default beverages

    // Initialize animation controllers
    _animationControllers = List.generate(
      quickProductsCount,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 100),
        vsync: this,
      ),
    );

    // Initialize scale animations
    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 1.0,
        end: 0.95,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    // Initialize button keys for animation targets
    _buttonKeys = List.generate(quickProductsCount, (index) => GlobalKey());
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BeverageProvider, IntakeProvider>(
      builder: (context, beverageProvider, intakeProvider, child) {
        if (beverageProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final defaultBeverages = beverageProvider.defaultBeverages;

        if (defaultBeverages.isEmpty) {
          return const Center(child: Text('Nessuna bevanda disponibile'));
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: defaultBeverages.length > 4 ? 4 : defaultBeverages.length,
          itemBuilder: (context, index) {
            final beverage = defaultBeverages[index];

            return AnimatedBuilder(
              animation: _scaleAnimations[index],
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimations[index].value,
                  child: _buildQuickAddCard(beverage, index),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildQuickAddCard(Beverage beverage, int index) {
    return Container(
      key: _buttonKeys[index],
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [beverage.color, beverage.color.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: CustomBoxShadow.cardBoxShadows,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: _isAnimationInProgress
              ? null
              : () => _onBeverageTap(beverage, index),
          onLongPress: () => _onBeverageLongPress(beverage),
          child: Stack(
            children: [
              // Background watermark icon - large and rotated
              Positioned(
                top: -40,
                right: -20,
                bottom: 0,
                child: Transform.rotate(
                  angle: 0.3, // ~12 degrees rotation
                  child: Image.asset(
                    beverage.imagePath,
                    width: 100,
                    height: 100,
                    opacity: const AlwaysStoppedAnimation(0.2),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to icon if image fails to load
                      return Icon(
                        _getIconForBeverage(beverage.name),
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Beverage image
                    Image.asset(
                      beverage.imagePath,
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to icon if image fails to load
                        return Icon(
                          _getIconForBeverage(beverage.name),
                          color: Colors.white,
                          size: 32,
                        );
                      },
                    ),
                    const Spacer(),
                    // Beverage name
                    Text(
                      beverage.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Caffeine amount with pill background
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${beverage.caffeineAmount.toInt()}mg',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Add button
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    LucideIcons.plus,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForBeverage(String name) {
    final lowerName = name.toLowerCase();

    if (lowerName.contains('espresso') || lowerName.contains('coffee')) {
      return LucideIcons.coffee;
    } else if (lowerName.contains('tea') || lowerName.contains('tè')) {
      return LucideIcons.coffee; // Could be a tea icon if available
    } else if (lowerName.contains('energy')) {
      return LucideIcons.zap;
    } else if (lowerName.contains('cola') || lowerName.contains('soda')) {
      return LucideIcons.glassWater;
    } else {
      return LucideIcons.coffee;
    }
  }

  Future<void> _onBeverageTap(Beverage beverage, int index) async {
    if (_isAnimationInProgress) return;

    setState(() {
      _isAnimationInProgress = true;
    });

    // Play scale animation
    await _animationControllers[index].forward();
    await _animationControllers[index].reverse();

    // Add haptic feedback
    HapticFeedback.mediumImpact();

    // Start drink to gauge animation if gauge key is available
    if (widget.gaugeKey != null && widget.gaugeKey!.currentContext != null) {
      AnimationOverlayService.startDrinkToGaugeAnimation(
        context: context,
        beverage: beverage,
        buttonKey: _buttonKeys[index],
        gaugeKey: widget.gaugeKey!,
        onComplete: () {
          // Animation completed, add intake
          _addIntake(beverage);
          setState(() {
            _isAnimationInProgress = false;
          });
        },
      );
    } else {
      // Fallback: just add intake without animation
      await _addIntake(beverage);
      setState(() {
        _isAnimationInProgress = false;
      });
    }
  }

  Future<void> _addIntake(Beverage beverage) async {
    try {
      final intakeProvider = Provider.of<IntakeProvider>(
        context,
        listen: false,
      );

      final intake = Intake(
        id: 'intake_${DateTime.now().millisecondsSinceEpoch}',
        beverage: beverage,
        timestamp: DateTime.now(),
      );

      await intakeProvider.addIntake(intake);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${beverage.name} aggiunto!'),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Errore nell\'aggiunta'),
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _onBeverageLongPress(Beverage beverage) {
    // Handle long press (e.g., show options to edit or remove)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherIntakesScreen(modifybeverage: beverage),
      ),
    );
  }
}
