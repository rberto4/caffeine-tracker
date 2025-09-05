import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/models/intake.dart';
import '../../utils/app_colors.dart';

/// Modern-styled list item widget for displaying a caffeine intake
class ModernIntakeListItem extends StatelessWidget {
  final Intake intake;
  final VoidCallback? onDelete;

  const ModernIntakeListItem({
    super.key,
    required this.intake,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Beverage icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: intake.beverage.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIconForBeverage(intake.beverage.name),
                color: intake.beverage.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Beverage name
                  Text(
                    intake.beverage.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Details row
                  Row(
                    children: [
                      Icon(
                        LucideIcons.coffee,
                        size: 12,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${intake.beverage.caffeineAmount.toInt()}mg',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        LucideIcons.droplet,
                        size: 12,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${intake.beverage.volume.toInt()}ml',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Time and actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  intake.formattedTime,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                if (onDelete != null)
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        LucideIcons.trash2,
                        size: 16,
                        color: AppColors.error,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForBeverage(String name) {
    final lowerName = name.toLowerCase();
    
    if (lowerName.contains('espresso') || lowerName.contains('coffee')) {
      return LucideIcons.coffee;
    } else if (lowerName.contains('tea') || lowerName.contains('tè')) {
      return LucideIcons.coffee; // Use coffee icon for now
    } else if (lowerName.contains('energy')) {
      return LucideIcons.zap;
    } else if (lowerName.contains('cola') || lowerName.contains('soda')) {
      return LucideIcons.glassWater;
    } else {
      return LucideIcons.coffee;
    }
  }
}
