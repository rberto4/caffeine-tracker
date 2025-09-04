import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/models/caffeine_intake.dart';
import '../../utils/app_colors.dart';
import '../../utils/drink_categories.dart';
import 'drink_icon.dart';

/// Modern intake list item with dynamic colors and improved design
class ModernIntakeListItem extends StatelessWidget {
  final CaffeineIntake intake;
  final VoidCallback? onDelete;
  final bool showDeleteButton;
  final bool showFullDate;

  const ModernIntakeListItem({
    super.key,
    required this.intake,
    this.onDelete,
    this.showDeleteButton = true,
    this.showFullDate = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final backgroundColor = _getBackgroundColor();
    final accentColor = _getAccentColor();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildIcon(backgroundColor, accentColor),
            const SizedBox(width: 16),
            Expanded(
              child: _buildContent(textTheme, accentColor, context),
            ),
            _buildTrailing(textTheme, context),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(Color backgroundColor, Color accentColor) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: DrinkIcon(
          productName: intake.productName,
          size: 32,
          showBackground: false,
        ),
      ),
    );
  }

  Widget _buildContent(TextTheme textTheme, Color accentColor, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intake.productName,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            '${intake.caffeineAmount.toInt()}mg caffeina',
            style: textTheme.labelSmall?.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              LucideIcons.clock,
              size: 14,
              color: AppColors.grey500,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                showFullDate 
                  ? '${intake.formattedDate} at ${intake.formattedTime}'
                  : intake.formattedTime,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.grey500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (intake.quantity != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                LucideIcons.droplet,
                size: 14,
                color: AppColors.grey500,
              ),
              const SizedBox(width: 4),
              Text(
                'Qty: ${intake.quantity}',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTrailing(TextTheme textTheme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDeleteButton && onDelete != null)
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Icon(
                LucideIcons.trash2,
                size: 18,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
      ],
    );
  }

  /// Ottiene il colore di sfondo basato sulla categoria del drink
  Color _getBackgroundColor() {
    final category = DrinkCategories.getCategory(intake.productName);
    
    switch (category) {
      case DrinkCategories.espressoCategory:
        return const Color(0xFF8B5CF6).withValues(alpha: 0.1); // Purple
      case DrinkCategories.coffeeCategory:
        return const Color(0xFF3B82F6).withValues(alpha: 0.1); // Blue
      case DrinkCategories.energyDrinkCategory:
        return const Color(0xFFEF4444).withValues(alpha: 0.1); // Red
      case DrinkCategories.sodaCategory:
        return const Color(0xFF10B981).withValues(alpha: 0.1); // Green
      default:
        return AppColors.primaryOrange.withValues(alpha: 0.1); // Orange
    }
  }

  /// Ottiene il colore principale basato sulla categoria del drink
  Color _getAccentColor() {
    final category = DrinkCategories.getCategory(intake.productName);
    
    switch (category) {
      case DrinkCategories.espressoCategory:
        return const Color(0xFF8B5CF6); // Purple
      case DrinkCategories.coffeeCategory:
        return const Color(0xFF3B82F6); // Blue
      case DrinkCategories.energyDrinkCategory:
        return const Color(0xFFEF4444); // Red
      case DrinkCategories.sodaCategory:
        return const Color(0xFF10B981); // Green
      default:
        return AppColors.primaryOrange; // Orange
    }
  }
}
