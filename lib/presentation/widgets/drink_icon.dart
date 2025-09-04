import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../utils/app_colors.dart';
import '../../utils/drink_categories.dart';

/// Widget to display drink icon based on product name
class DrinkIcon extends StatelessWidget {
  final String productName;
  final double size;
  final bool showBackground;
  final Color? backgroundColor;

  const DrinkIcon({
    super.key,
    required this.productName,
    this.size = 32,
    this.showBackground = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final drinkInfo = DrinkCategories.getDrinkInfo(productName);
    
    // If it's a custom product, try to guess the image
    final finalImagePath = drinkInfo?.imagePath ?? 
        DrinkCategories.getDefaultImageForCustomProduct(productName);

    Widget iconWidget = Container(
      width: size,
      height: size,
      padding: showBackground ? EdgeInsets.all(size * 0.15) : EdgeInsets.zero, // No padding if no background
      decoration: showBackground ? BoxDecoration(
        color: backgroundColor ?? AppColors.primaryOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(size * 0.2), // 20% border radius
      ) : null,
      child: Image.asset(
        finalImagePath,
        width: showBackground ? null : size * 0.8, // Slightly smaller when no background
        height: showBackground ? null : size * 0.8,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to Lucide icon if image fails to load
          return Icon(
            LucideIcons.coffee,
            color: showBackground ? AppColors.primaryOrange : Colors.white,
            size: size * 0.6,
          );
        },
      ),
    );

    return iconWidget;
  }
}
