import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/beverage_provider.dart';
import '../../domain/providers/intake_provider.dart';
import '../../domain/models/intake.dart';
import '../../domain/models/beverage.dart';
import '../../utils/app_colors.dart';

/// Grid showing quick add buttons for default beverages
class QuickAddGrid extends StatefulWidget {
  final GlobalKey? gaugeKey;

  const QuickAddGrid({
    super.key,
    this.gaugeKey,
  });

  @override
  State<QuickAddGrid> createState() => _QuickAddGridState();
}

class _QuickAddGridState extends State<QuickAddGrid>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
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
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();
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
          return const Center(
            child: Text('Nessuna bevanda disponibile'),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
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
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isAnimationInProgress ? null : () => _onBeverageTap(beverage, index),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Beverage image
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: beverage.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconForBeverage(beverage.name),
                    color: beverage.color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                // Beverage name
                Text(
                  beverage.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey800,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Caffeine amount
                Text(
                  '${beverage.caffeineAmount.toInt()}mg',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey600,
                  ),
                ),
                const SizedBox(height: 4),
                // Volume
                Text(
                  '${beverage.volume.toInt()}ml',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
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

    // Play animation
    await _animationControllers[index].forward();
    await _animationControllers[index].reverse();

    // Add haptic feedback
    HapticFeedback.mediumImpact();

    // Add intake
    await _addIntake(beverage);

    setState(() {
      _isAnimationInProgress = false;
    });
  }

  Future<void> _addIntake(Beverage beverage) async {
    try {
      final intakeProvider = Provider.of<IntakeProvider>(context, listen: false);
      
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
}
