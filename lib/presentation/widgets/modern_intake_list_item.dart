import 'package:caffeine_tracker/presentation/widgets/box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/models/intake.dart';
import '../../utils/app_colors.dart';

/// Modern-styled list item widget for displaying a caffeine intake
class ModernIntakeListItem extends StatelessWidget {
  final Intake intake;
  final VoidCallback? onDelete;

  const ModernIntakeListItem({super.key, required this.intake, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
       boxShadow: CustomBoxShadow.cardBoxShadows,
         gradient: LinearGradient(
          colors: [
            intake.beverage.color.withValues(alpha: 1),
            intake.beverage.color.withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        //color: intake.beverage.color.withAlpha(20),
        borderRadius: BorderRadius.circular(24),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Row(
          children: [
            // Beverage icon
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: CustomBoxShadow.iconBoxShadows
              ),
              child: Image.asset(
                intake.beverage.imagePath,
                width: 72,
                height: 72,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if image fails to load
                  return Icon(
                    _getIconForBeverage(intake.beverage.name),
                    size: 32,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Beverage name
                  Text(
                    intake.beverage.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Details row
                  Row(
                    children: [
                      Icon(
                        LucideIcons.fuel,
                        size: 18,
                        color: AppColors.beverageBrown,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${intake.beverage.caffeineAmount.toInt()}mg',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 1),
                        ),
                      ),
                                      
                    ],
                  ),
                  Row(
                    children: [
                       Icon(
                        LucideIcons.droplet,
                        size: 18,
                        color: AppColors.beverageBlue.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${intake.beverage.volume.toInt()}ml',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha:1),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        DateTime.now().difference(intake.timestamp).inDays <= 1
                            ? LucideIcons.clock
                            : LucideIcons.calendarClock,
                        size: 18,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateTime.now().difference(intake.timestamp).inDays <= 1
                            ? intake.formattedTime
                            : '${intake.formattedDate} at ${intake.formattedTime}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha : 1),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
           
            if (onDelete != null)
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  LucideIcons.trash2,
                  size: 18,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
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
