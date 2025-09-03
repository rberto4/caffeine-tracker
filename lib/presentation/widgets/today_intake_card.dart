import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/caffeine_provider.dart';
import '../../utils/app_colors.dart';

/// Card widget displaying today's caffeine intake summary
class TodayIntakeCard extends StatelessWidget {
  const TodayIntakeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Consumer<CaffeineProvider>(
      builder: (context, caffeineProvider, child) {
        final todayIntakes = caffeineProvider.todayIntakes;
        final totalCaffeine = caffeineProvider.todayTotalCaffeine;
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      LucideIcons.coffee,
                      color: AppColors.primaryOrange,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Today\'s Intake',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              if (todayIntakes.isEmpty) 
                _buildEmptyState(textTheme)
              else
                _buildIntakesList(todayIntakes, totalCaffeine, textTheme, context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(TextTheme textTheme) {
    return Column(
      children: [
        Icon(
          LucideIcons.coffee,
          size: 48,
          color: AppColors.grey300,
        ),
        const SizedBox(height: 12),
        Text(
          'No caffeine intake today',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.grey500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Start tracking your caffeine consumption',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.grey400,
          ),
        ),
      ],
    );
  }

  Widget _buildIntakesList(
    List<dynamic> intakes, 
    double totalCaffeine, 
    TextTheme textTheme,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary
        _buildSummaryRow(intakes.length, totalCaffeine, textTheme),
        
        const SizedBox(height: 16),
        
        // Recent intakes (max 3)
        ...intakes.take(3).map((intake) => _buildIntakeItem(intake, textTheme)),
        
        if (intakes.length > 3) ...[
          const SizedBox(height: 8),
          Text(
            '+${intakes.length - 3} more items',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.grey500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryRow(int count, double totalCaffeine, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$count ${count == 1 ? 'Item' : 'Items'}',
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.grey700,
              ),
            ),
            Text(
              'Total consumed',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${totalCaffeine.toInt()}mg',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryOrange,
              ),
            ),
            Text(
              'Caffeine',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIntakeItem(dynamic intake, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey100.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  intake.productName,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey800,
                  ),
                ),
                Text(
                  intake.formattedTime,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${intake.caffeineAmount.toInt()}mg',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryOrange,
            ),
          ),
        ],
      ),
    );
  }
}
