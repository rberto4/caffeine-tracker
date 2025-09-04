import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/caffeine_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/animation_overlay_service.dart';
import 'drink_icon.dart';

/// Grid showing quick add buttons for common caffeine products
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
  final List<GlobalKey> _buttonKeys = []; // Chiavi per ogni pulsante
  bool _isAnimationInProgress = false; // Flag per bloccare tap multipli

  @override
  void initState() {
    super.initState();
    
    const quickProductsCount = 4; // Number of quick products
    
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
    
    // Initialize button keys
    for (int i = 0; i < quickProductsCount; i++) {
      _buttonKeys.add(GlobalKey());
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quickProducts = [
      {'name': 'Espresso (30ml)', 'caffeine': 63.0},
      {'name': 'Coffee (240ml)', 'caffeine': 95.0},
      {'name': 'Red Bull (250ml)', 'caffeine': 80.0},
      {'name': 'Green Tea (240ml)', 'caffeine': 25.0},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 0.9,
      ),
      itemCount: quickProducts.length,
      itemBuilder: (context, index) {
        final product = quickProducts[index];
        return AnimatedBuilder(
          animation: _scaleAnimations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimations[index].value,
              child: Opacity(
                opacity: _isAnimationInProgress ? 0.7 : 1.0, // Riduce opacità durante animazione
                child: _buildQuickAddCard(
                  context,
                  product['name'] as String,
                  product['caffeine'] as double,
                  index,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuickAddCard(
    BuildContext context,
    String productName,
    double caffeineAmount,
    int index,
  ) {
    final textTheme = Theme.of(context).textTheme;
    
    // Define gradient colors for different drink types
    final gradientColors = _getGradientColors(productName);
    
    return Material(
      key: _buttonKeys[index],
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleCardTap(context, productName, caffeineAmount, index),
        onTapDown: (_) => _animationControllers[index].forward(),
        onTapUp: (_) => _animationControllers[index].reverse(),
        onTapCancel: () => _animationControllers[index].reverse(),
        borderRadius: BorderRadius.circular(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
              ],
            ),
          child: Stack(
            children: [
              // Large background icon - positioned on the right, rotated and extending beyond bounds
              Positioned(
                right: -40, // Extended further outside
                top: -20,
                child: Transform.rotate(
                  angle: 0.4, // Slightly more rotation (~23 degrees)
                  child: Opacity(
                    opacity: 0.15, // More subtle
                    child: DrinkIcon(
                      productName: productName,
                      size: 140, // Even larger for better background effect
                      showBackground: false,
                    ),
                  ),
                ),
              ),
              
              // Content column with specific padding for each element
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top section with main icon and plus button
                    DrinkIcon(
                      productName: productName,
                      size: 64,
                      showBackground: false,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Bottom section with text info - only padding on text elements
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name - with right padding to avoid background icon
                        Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Text(
                            productName.split('(')[0].trim(),
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Caffeine amount with background - no extra container padding
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(46),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                '${caffeineAmount.toInt()}mg',
                                style: textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    const Shadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Add button indicator - no extra padding
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            LucideIcons.plus,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  // Handle card tap with animation
  Future<void> _handleCardTap(
    BuildContext context,
    String productName,
    double caffeineAmount,
    int index,
  ) async {
    // Blocca se un'animazione è già in corso
    if (_isAnimationInProgress) return;
    
    // Haptic feedback
    HapticFeedback.lightImpact();
    
    // Add slight delay for visual feedback
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Start animation if gauge key is available
    if (widget.gaugeKey != null) {
      setState(() {
        _isAnimationInProgress = true;
      });
      
      AnimationOverlayService.startDrinkToGaugeAnimation(
        context: context,
        productName: productName,
        caffeineAmount: caffeineAmount,
        buttonKey: _buttonKeys[index],
        gaugeKey: widget.gaugeKey!,
        onComplete: () {
          // Add the intake after animation completes
          _addQuickIntake(context, productName, caffeineAmount);
          
          // Riabilita i tap
          setState(() {
            _isAnimationInProgress = false;
          });
        },
      );
    } else {
      // Fallback: add intake immediately if no animation
      _addQuickIntake(context, productName, caffeineAmount);
    }
  }

  // Define gradient colors based on product type
  List<Color> _getGradientColors(String productName) {
    final lowerName = productName.toLowerCase();
    
    if (lowerName.contains('espresso') || lowerName.contains('cappuccino')) {
      // Purple gradient for espresso drinks
      return [
        const Color(0xFF8B5CF6), // Purple
        const Color(0xFFA855F7), // Lighter purple
      ];
    } else if (lowerName.contains('coffee') || lowerName.contains('americano')) {
      // Blue gradient for regular coffee
      return [
        const Color(0xFF3B82F6), // Blue
        const Color(0xFF60A5FA), // Lighter blue
      ];
    } else if (lowerName.contains('energy') || lowerName.contains('red bull')) {
      // Orange/Red gradient for energy drinks
      return [
        const Color(0xFFEF4444), // Red
        const Color(0xFFF97316), // Orange
      ];
    } else if (lowerName.contains('tea')) {
      // Green gradient for tea
      return [
        const Color(0xFF10B981), // Emerald
        const Color(0xFF34D399), // Lighter emerald
      ];
    } else {
      // Default orange gradient
      return [
        AppColors.primaryOrange,
        const Color(0xFFFF8A50), // Lighter orange
      ];
    }
  }

  Future<void> _addQuickIntake(
    BuildContext context,
    String productName,
    double caffeineAmount,
  ) async {
    final caffeineProvider = Provider.of<CaffeineProvider>(context, listen: false);
    
        
    final success = await caffeineProvider.addIntake(
      productName: productName,
      caffeineAmount: caffeineAmount,
    );
    
    // Remove loading snackbar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                LucideIcons.checkCircle,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Added $productName',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                LucideIcons.xCircle,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Failed to add intake. Please try again.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

}
